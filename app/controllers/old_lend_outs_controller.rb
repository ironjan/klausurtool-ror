class OldLendOutsController < ApplicationController
  layout "ausleihe", except: "error"

  def index
    @old_lend_outs = OldLendOut.all
  end

  def new
    @old_lend_out = OldLendOut.new
    @currently_lent_outs = OldLendOut.where(:receivingTime => nil)
  end


  def create
    @old_lend_out = OldLendOut.new(old_lend_out_params)

    old_folder_instances = folderList2oldFolderInstances
    mixed_content = hasMixedContent?(old_folder_instances)

    unavailable_folders = old_folder_instances.reject { |f| f.old_lend_out.nil? }
    unavailable_folders.each { |f| @old_lend_out.errors.add(:base, "#{f.barcodeId} is not available.") }
    all_available = unavailable_folders.empty?

    unless @old_lend_out.errors.empty?
      render 'new'
      return
    end

    # Add time
    @old_lend_out.lendingTime = Time.new

    # No errors, now we start lending
    OldLendOut.transaction do
      if @old_lend_out.save!
        old_folder_instances.each do |i|
          i.old_lend_out = @old_lend_out
          i.save!
          Rails.logger.debug("Saved #{i.inspect}")
        end
      end
    end

    render 'success'
  rescue Exception => ex
    @old_lend_out.errors.add(:base, "Exception prevented save: #{ex}")
    render 'new'
  end

  # This controller method is used to decide if we are lending or returning folders. It redirects to the corresponding
  # form.
  def switch
    old_folder_instances = folderList2oldFolderInstances

    if hasMixedContent?(old_folder_instances)
      flash[:alert] = "Eingabe enthält gemischte Ordner. Entweder Ausleihen oder Zurücknehmen."
      redirect_to old_lend_outs_path
      return
    end

    if old_folder_instances.first().old_lend_out.nil?
      redirect_to lending_form_path(old_folder_instances: old_folder_instances)
    else
      redirect_to returning_form_path(old_folder_instances: old_folder_instances)
    end
  end

  # Renders the form when lending folder_instances. The form calls lending_action on submit.
  def lending_form
    @old_folder_instances = params[:old_folder_instances].map { |id| OldFolderInstance.find(id) }
    @old_lend_out = OldLendOut.new
    @old_lend_out.old_folder_instances = @old_folder_instances
  end

  # Lents the given folders and returns the user to the main screen.
  def lending_action
    Rails.logger.debug("#{params}")
    old_lend_out = OldLendOut.new(old_lend_out_params)
    Rails.logger.debug("#{old_lend_out}")

    if hasMixedContent?(old_lend_out.old_folder_instances)
      flash[:alert] = "Eingabe enthält gemischte Ordner. Entweder Ausleihen oder Zurücknehmen."
      redirect_to old_lend_outs_path
    end

    Rails.logger.debug("#{old_lend_out}")

    isAlreadyLent = (old_lend_out.old_folder_instances.first().old_lend_out.nil?)
    Rails.logger.debug("#{isAlreadyLent}")

    if isAlreadyLent
      flash[:alert] = "Es wurde versucht, bereits verliehene Ordner auszuleihen."
    end

    Rails.logger.debug("Starting transaction")
    # OldLendOut.transaction do
      old_lend_out.save!
      old_lend_out.old_folder_instances.each do |id|
        instance = OldFolderInstance.find(id)
        instance.old_lend_out = @old_lend_out
        instance.save!
    #  end
    end
    Rails.logger.debug("transaction done")
    flash[:notify] = "Ordner erfolgreich verliehen"
    redirect_to old_lend_outs_path

  #rescue Exception => ex
  #  flash[:alert] = "Fehler beim Speichern: #{ex}"
  #  redirect_to old_lend_outs_path
  end

  # Renders the form when returning folder_instances. The form calls returning_action on submit.
  def returning_form
    #fixme: implement and add layout
  end

  # Takes the given folders back and returns the user to the main screen.
  def returning_action
    #fixme: implement and add layout
  end


  private
  def old_lend_out_params
    params.require(:old_lend_out).permit(:imt, :lender, :deposit, :student, :old_folder_instances => [])
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

  def folderList2oldFolderInstances
    folderList = params[:folderList].split(/\r?\n/)

    old_folder_instances = []

    folderList.each do |f|
      next if f.empty?
      # FIXME map to short barcode if long
      old_folder_instance = OldFolderInstance.find_by(barcodeId: f)
      if old_folder_instance.nil?
        @old_lend_out.errors.add(:base, "Es gibt kein Ordner-Exemplar #{f}.")
        Rails.logger.debug("Added error for #{f}")
      else
        old_folder_instances << old_folder_instance
      end
    end
    old_folder_instances
  end
end