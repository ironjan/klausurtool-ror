class AusleiheController < ApplicationController
  include LentFolders, LendingArchive, PaginatedFolderInstanceList, PaginatedExamsList, AusleiheHelper



  layout 'ausleihe', except: 'error'


  def index
  end

  def folders
    paginated_folder_instance_list
  end

  def folder_details
    @old_folder = OldFolder.find_by_id(params[:id])
  end

  def exams
    paginated_exams_list
  end

  # This controller method is used to decide if we are lending or returning folders. It redirects to the corresponding
  # form.
  def switch
    folder_list = params[:folderList].split(/\r?\n/)

    instances = []
    warnings = []

    Rails.logger.debug("Got switch request containing #{folder_list.count} elements.")
    folder_list = folder_list
                      .map { |f| [f, f.strip] }
                      .reject { |_, stripped| stripped.empty? }
                      .map { |f, stripped| [f, string_to_barcode_id(stripped)] }

    folder_list.each do |f, stripped|
      Rails.logger.debug(" `#{f}` has been stripped to `#{stripped}` and was not empty.")

      barcode_id = stripped

      if barcode_id.length != 4
        flash[:alert] = "#{Time.new}: \"#{f}\" ist keine korrekte ID und kein korrekter Barcode. Ein Reparaturversuch schlug fehl."
        redirect_to ausleihe_path and return
      elsif barcode_id != f
        warnings << "`#{f}` wurde zu `#{barcode_id}` abgeändert."
      end

      old_folder_instance = OldFolderInstance.find_by(barcodeId: barcode_id)

      if old_folder_instance.nil?
        flash[:alert] = "#{Time.new}: Es gibt kein Ordner-Exemplar `#{barcode_id}` (Basierend auf `#{f}`)."
        redirect_to ausleihe_path and return
      else
        instances << old_folder_instance
      end
    end

    lent_instances = instances.reject { |i| i.old_lend_out.nil? }


    if warnings.count > 0
      flash[:warning] = warnings.join(' ')
    end


    if lent_instances.empty?
      redirect_to lending_form_path(old_folder_instances: instances) and return

    elsif lent_instances.count == instances.count
      redirect_to returning_form_path(old_folder_instances: instances) and return

    else
      lent_as_strings = lent_instances
                            .map { |i| i.barcodeId }
                            .join(', ')
      all_as_strings = instances.map { |i| i.barcodeId }
                           .join(', ')

      message = ["#{Time.new}: Eingabe enthält gemischte Ordner. Entweder Ausleihen oder Zurücknehmen."]
      message << "Ordner-Exemplare: #{all_as_strings}, davon verliehen: #{lent_as_strings}"
      flash[:alert] = message.join

      redirect_to ausleihe_path and return
    end
  end

  # Renders the form when lending folder_instances. The form calls lending_action on submit.
  def lending_form
    old_folder_instances = params[:old_folder_instances]
    if old_folder_instances.nil? || old_folder_instances.empty?
      flash[:alert] = "#{Time.new}: Verleih-Formular kann nicht ohne Ordner aufgerufen werden."
      redirect_to ausleihe_path and return
    end


    instances = old_folder_instances
                    .map { |id| OldFolderInstance.find_by_id(id) }
    found_instances = instances.compact

    if found_instances.count < instances.count
      flash[:alert] = "#{Time.new}: Einige Ordner konnten nicht gefunden werden. Wurde diese URL direkt aufgerufen?"
      redirect_to ausleihe_path and return
    end

    @old_lend_out = OldLendOut.new
    @old_lend_out.old_folder_instances = found_instances
  end

  # Lents the given folders and returns the user to the main screen.
  def lending_action

    if params[:old_lend_out].nil?
      render "ausleihe/lending_form" and return
    end

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
    old_folder_instances = params[:old_folder_instances]

    if old_folder_instances.nil? || old_folder_instances.empty?
      flash[:alert] = "#{Time.new}: Rückgabe-Formular darf nicht ohne Ordner aufgerufen werden."
      redirect_to ausleihe_path and return
    end

    instances = old_folder_instances
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
    if params[:id].nil?
      render 'ausleihe/returning_form' and return
    end

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