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

    Rails.logger.debug("Got switch request containing #{folder_list.count} elements.")
    folder_list = folder_list
                      .map { |i| input_to_stripped_input_tuple(i) }
                      .reject { |_, stripped| stripped.empty? }
                      .map { |f, stripped| append_instance_to_tuple(f, string_to_barcode_id(stripped)) }


    non_existing_instances = folder_list
                                 .select { |_, _, instance| instance.nil? }
                                 .map { |barcode, f| input_barcode_to_output_string(barcode, f) }

    corrected_codes = folder_list
                          .select { |f, barcode_id, _| f != barcode_id && f.length != 4 && f.length != 8 }
                          .map { |barcode, f| input_barcode_to_output_string(barcode, f) }


    lent_instances = folder_list.reject { |_, _, i| i.nil? || i.old_lend_out.nil? }


    unless corrected_codes.empty?
      flash[:warning] = "#{Time.new}: IDs wurden korrigiert: #{corrected_codes.join(', ')}"
    end

    has_non_existing_instances = (not non_existing_instances.empty?)
    if has_non_existing_instances
      flash[:alert] = "#{Time.new}: Folgende Ordner konnten nicht gefunden werden: #{non_existing_instances.join(', ')}"
      redirect_to ausleihe_path and return
    end

    has_mixed_content = (not lent_instances.empty?) && lent_instances.count != folder_list.count

    if has_mixed_content
      flash[:alert] = invalid_input_for_switch_message(folder_list, lent_instances)
      redirect_to ausleihe_path and return
    end

    redirect_to_after_switch_action(lent_instances.empty?, folder_list)
  end

  # Redirects the user to the next action. If lending is true, the user will be redirected to the lending form;
  # otherwise the user will be redirected to the returning form.
  def redirect_to_after_switch_action(lending, folder_list)
    instances_only = folder_list.map { |_, _, i| i }
    if lending
      redirect_to lending_form_path(old_folder_instances: instances_only)
    else
      redirect_to returning_form_path(old_folder_instances: instances_only)
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

  # folder_list
  #     .map { |f| [f, f.strip] }
  #     .reject { |_, stripped| stripped.empty? }
  #     .map { |f, stripped| [f, string_to_barcode_id(stripped)] }
  #     .map { |f, barcode_id| [f, barcode_id, OldFolderInstance.find_by(barcodeId: barcode_id)] }

  def input_to_stripped_input_tuple(input)
    [input, input.strip]
  end

  def append_instance_to_tuple(f, barcode_id)
    [f, barcode_id, OldFolderInstance.find_by(barcodeId: barcode_id)]
  end

  def input_barcode_to_output_string(barcode, f)
    "#{barcode} (#{f})"
  end

  def invalid_input_for_switch_message(folder_list, lent)
    lent_as_strings = lent
                          .map { |barcode, f| input_barcode_to_output_string(barcode, f) }
                          .join(', ')
    all_as_strings = folder_list
                         .map { |barcode, f| input_barcode_to_output_string(barcode, f) }
                         .join(', ')

    "#{Time.new}: Eingabe enthält gemischte Ordner. Entweder Ausleihen oder Zurücknehmen. Ordner-Exemplare: #{all_as_strings}, davon verliehen: #{lent_as_strings}"
  end


end