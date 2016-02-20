class AusleiheController < ApplicationController
  include LentFolders, LendingArchive, PaginatedFolderInstanceList, PaginatedExamsList


  layout 'ausleihe', except: 'error'


  def index
  end

  def folders
    paginated_folder_instance_list
  end

  def exams
    paginated_exams_list
  end

  # This controller method is used to decide if we are lending or returning folders. It redirects to the corresponding
  # form.
  def switch
    folderList = params[:folderList].split(/\r?\n/)

    instances = []
    warnings = []

    Rails.logger.debug("Got switch request containing #{folderList.count} elements.")
    folderList = folderList.map { |f| f.strip }
                     .reject { |f| f.empty? }

    folderList.each do |f|
      Rails.logger.debug(" `#{f}` has been stripped and was not empty.")

      if f.length == 4
        Rails.logger.debug(" `#{f}` is 4 chars long. barcodeId will be #{f}.")
        barcodeId = f
      elsif f.length == 8
        Rails.logger.debug(" `#{f}` is 8 chars long. barcodeId will be #{f[3..6]}.")
        barcodeId = f[3..6]
      else

        # Workaround for invalid barcodes taped on folders
        # remove leading zeros, then take the first four values (if existing)
        workaround_f = f.sub!(/^0*/, "")[0..3]
        Rails.logger.warn("Input `#{f}` for folderId or barcode was modified to `#{workaround_f}`.")


        if workaround_f.length != 4
          flash[:alert] = "#{Time.new}: \"#{f}\" ist keine korrekte ID und kein korrekter Barcode. Ein Reparaturversuch schlug fehl."
          redirect_to ausleihe_path and return
        else
          warnings << "`#{f}` wurde zu `#{workaround_f}` abgeändert."
          barcodeId = workaround_f
        end
      end

      old_folder_instance = OldFolderInstance.find_by(barcodeId: barcodeId)

      if old_folder_instance.nil?
        flash[:alert] = "#{Time.new}: Es gibt kein Ordner-Exemplar \"#{f}\"."
        redirect_to ausleihe_path and return
      else
        instances << old_folder_instance
      end
    end

    lent_instances = instances.reject { |i| i.old_lend_out.nil? }


    if warnings.count > 0
      warnings << 'Falls Barcodes gescannt wurden, sind diese möglicherweise fehlerhaft erstellt worden.'
      flash[:warning] = warnings.join(' ')
    end


    if lent_instances.empty?
      redirect_to lending_form_path(old_folder_instances: instances) and return

    elsif lent_instances.count == instances.count
      redirect_to returning_form_path(old_folder_instances: instances) and return

    else
      lentAsStrings = lent_instances
                          .map { |i| i.barcodeId }
                          .join(', ')
      allAsStrings = instances.map { |i| i.barcodeId }
                         .join(', ')

      message = ["#{Time.new}: Eingabe enthält gemischte Ordner. Entweder Ausleihen oder Zurücknehmen."]
      message << "Ordner-Exemplare: #{allAsStrings}, davon verliehen: #{lentAsStrings}"
      flash[:alert] = message.join

      redirect_to ausleihe_path and return
    end
  end

  # Renders the form when lending folder_instances. The form calls lending_action on submit.
  def lending_form
    instances = params[:old_folder_instances]
                    .map { |id| OldFolderInstance.find_by_id(id) }
    found_instances = instances.compact

    if found_instances.count < instances.count
      flash[:alert] = "#{Time.new}: Einige Ordner konnten nicht gefunden werden. Wurde diese URL direkt aufgerufen?"
    end

    @old_lend_out = OldLendOut.new
    @old_lend_out.old_folder_instances = found_instances
  end

  # Lents the given folders and returns the user to the main screen.
  def lending_action
    Rails.logger.debug("#{params}")
    @old_lend_out = OldLendOut.new(old_lend_out_params)
    instances = params[:old_folder_instances]
                    .map { |id| OldFolderInstance.find_by_id(id) }
    found_instances = instances.compact

    if found_instances.count < instances.count
      # fixme: Handle error. We did not find all instances that were given
    end

    all_available = found_instances
                        .map { |i| i.old_lend_out }
                        .compact
                        .empty?

    unless all_available
      flash[:alert] = "#{Time.new}: Einige der Ordner sind bereits verliehen."
      redirect_to ausleihe_path and return
    end

    @old_lend_out.old_folder_instances = found_instances

    @old_lend_out.lendingTime = Time.new

    OldLendOut.transaction do
      unless @old_lend_out.save!
      end
    end

    flash[:notice] = "#{Time.new}: Ordner erfolgreich verliehen"
    redirect_to ausleihe_path
  end

  # Renders the form when returning folder_instances. The form calls returning_action on submit.
  def returning_form
    instances = params[:old_folder_instances]
                    .map { |id| OldFolderInstance.find_by_id(id) }
    found_instances = instances.compact

    if found_instances.count < instances.count
      flash[:alert] << "#{Time.new}: Einige Ordner konnten nicht gefunden werden. Wurde diese URL direkt aufgerufen?"
    end

    old_lend_outs = found_instances.map { |i| i.old_lend_out }.uniq
    if old_lend_outs.count > 1
      flash[:alert] = "#{Time.new}: Die eingegebenen Ordner gehören zu verschiedenen Ausleih-Vorgängen."
      redirect_to ausleihe_path and return
    end

    @old_lend_out = old_lend_outs.first
  end

  # Takes the given folders back and returns the user to the main screen.
  def returning_action
    @old_lend_out = OldLendOut.find(params[:id])

    @old_lend_out.receivingTime = Time.new

    OldLendOut.transaction do
      if @old_lend_out.update!(old_lend_out_params)
        @old_lend_out.old_folder_instances.each do |i|
          i.old_lend_out = nil
          i.save!
        end

        # archive
        archive(@old_lend_out)
        @old_lend_out.destroy!

        flash[:notice] = "#{Time.new}: Ordner erfolgreich zurückgenommen"
        redirect_to ausleihe_path and return
      else
        render 'returning_form' and return
      end
    end

  end


  private
  def old_lend_out_params
    params.require(:old_lend_out).permit(:imt, :lender, :deposit, :weigth, :receiver, :recivingTime, :old_folder_instances => [])
  end


  def archive(old_lend_out)
    archived = ArchivedOldLendOut.new
    archived.old_folder_instances = old_lend_out.old_folder_instances
    archived.imt = old_lend_out.imt
    archived.lender = old_lend_out.lender
    archived.lendingTime = old_lend_out.lendingTime
    archived.deposit = old_lend_out.deposit
    archived.weigth = old_lend_out.weigth
    archived.receiver = old_lend_out.receiver
    archived.receivingTime = old_lend_out.receivingTime

    archived.save!
  end

  def has_mixed_content?(old_folder_instances)
    lend_outs = old_folder_instances.map { |i| i.old_lend_out }
    lent = lend_outs.reject { |l| l.nil? }

    if lent.empty?
      mixed_content = false
    else
      mixed_content = (lent.count != lend_outs.count)
    end

    mixed_content
  end
end