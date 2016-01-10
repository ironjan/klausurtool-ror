class AusleiheController < ApplicationController
  layout "ausleihe", except: "error"

  def index
  end

  def lent
    @old_lend_outs = OldLendOut.where(:receiver => nil)
  end

  def history
    @archived_lend_outs = ArchivedOldLendOut.paginate(:page => params[:page], :per_page => 50)
  end

  def folders
    if params[:reset]
      params[:search] = nil
    end

    if params[:search].nil? or params[:search].empty?
      @old_folder_instances = OldFolderInstance.all
    else
      @old_folder_instances = OldFolderInstance.joins(:old_folder)
                                  .where("old_folders.title LIKE ?", "%#{params[:search]}%")
    end
  end

  def exams
    if params[:reset]
      params[:search] = nil
    end

    if params[:search].nil? or params[:search].empty?
      @old_exams = OldExam.all
    else
      @old_exams = OldExam.joins(:old_folder)
                       .where("date = ? OR old_exams.title LIKE ? OR old_exams.examiners LIKE ? OR old_folders.title LIKE ?",
                              "#{params[:search]}", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
  end

  # This controller method is used to decide if we are lending or returning folders. It redirects to the corresponding
  # form.
  def switch
    folderList = params[:folderList].split(/\r?\n/)

    instances = []

    folderList.each do |f|
      next if f.empty?

      if f.length == 4
        barcodeId = f
      elsif f.length == 8
        barcodeId = f[3..6]
      end

      old_folder_instance = OldFolderInstance.find_by(barcodeId: barcodeId)

      if old_folder_instance.nil?
        @old_lend_out.errors.add(:base, "Es gibt kein Ordner-Exemplar #{f}.")
        Rails.logger.debug("Added error for #{f}")
      else
        instances << old_folder_instance
      end
    end

    lent_instances = instances.map { |i| i.old_lend_out }.compact

    if lent_instances.empty?
      redirect_to lending_form_path(old_folder_instances: instances) and return

    elsif (lent_instances.count == instances.count)
      redirect_to returning_form_path(old_folder_instances: instances) and return

    else
      flash[:alert] = "Eingabe enthält gemischte Ordner. Entweder Ausleihen oder Zurücknehmen."
      redirect_to ausleihe_path and return
    end
  end

  # Renders the form when lending folder_instances. The form calls lending_action on submit.
  def lending_form
    instances = params[:old_folder_instances]
                    .map { |id| OldFolderInstance.find_by_id(id) }
    found_instances = instances.compact

    if found_instances.count < instances.count
      flash[:alert] = "Einige Ordner konnten nicht gefunden werden. Wurde diese URL direkt aufgerufen?"
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
      flash[:alert] = "Einige der Ordner sind bereits verliehen."
      redirect_to ausleihe_path and return
    end

    @old_lend_out.old_folder_instances = found_instances

    @old_lend_out.lendingTime = Time.new

    OldLendOut.transaction do
      unless @old_lend_out.save!
      end
    end

    flash[:notify] = "Ordner erfolgreich verliehen"
    redirect_to ausleihe_path

    #rescue Exception => ex
    #  flash[:alert] = "Fehler beim Speichern: #{ex}"
    #  redirect_to ausleihe_path
  end

  # Renders the form when returning folder_instances. The form calls returning_action on submit.
  def returning_form
    instances = params[:old_folder_instances]
                    .map { |id| OldFolderInstance.find_by_id(id) }
    found_instances = instances.compact

    if found_instances.count < instances.count
      flash[:alert] << "Einige Ordner konnten nicht gefunden werden. Wurde diese URL direkt aufgerufen?"
    end

    old_lend_outs = found_instances.map { |i| i.old_lend_out }.uniq
    if old_lend_outs.count > 1
      flash[:alert] = "Die eingegebenen Ordner gehören zu verschiedenen Ausleih-Vorgängen."
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

        flash[:notice] = "Ordner erfolgreich zurückgenommen"
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

  def hasMixedContent?(old_folder_instances)
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