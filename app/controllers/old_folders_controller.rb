# Provides CRUD actions for folders
class OldFoldersController < ApplicationController
  include Searchable

  layout 'admin', except: 'toc'

  def index
    clear_search_on_reset
    @old_folders = OldFolder.search(params[:search])
                       .paginate(:page => params[:page], :per_page => 50)
  end

  def show
    @old_folder = OldFolder.find(params[:id])
  end

  def new
    @old_folder = OldFolder.new
  end

  def edit
    @old_folder = OldFolder.find(params[:id])
  end

  def create
    @old_folder = OldFolder.new(old_folder_params)

    Rails.logger.debug('Before loop')

    if @old_folder.save

      i = 1
      number_of_instances = params[:count].gsub(/\D/, '').to_i
      Rails.logger.debug("Loop values: #{i}, #{number_of_instances}")
      until i > number_of_instances
        barcode_id = "#{format('%03d', @old_folder.id)}#{i}"
        Rails.logger.debug("Trying to create instance #{i} with barcodeId #{barcode_id}")
        folder_instance_params = ActionController::Parameters.new({
                                                                      old_folder_instance: {
                                                                          number: i,
                                                                          barcodeId: barcode_id
                                                                      }
                                                                  })
        @old_folder.old_folder_instances.create(
            folder_instance_params.require(:old_folder_instance).permit(:number, :barcodeId))
        i += 1
      end

      redirect_to @old_folder
    else
      render 'new'
    end
  end

  def update
    @old_folder = OldFolder.find(params[:id])

    if @old_folder.update(old_folder_params)
      redirect_to @old_folder
    else
      render 'edit'
    end
  end

  def destroy
    @old_folder = OldFolder.find(params[:id])
    @old_folder.destroy
    redirect_to old_folders_path
  end

  # Generates a table of contents from the given params[:old_folder_id]
  # TODO: Move to Internal::Admin::PrintController
  def toc
    id = params[:old_folder_id]
    if id.nil?
      flash[:alert] = 'Kein Ordner angegeben.' and return
    end

    @old_folder = OldFolder.find_by_id(id)

    if @old_folder.nil?
      flash[:alert] = "Ordner mit Id `#{id}` nicht gefunden."
      @old_folder = OldFolder.new
    end

    @unarchived_exams = @old_folder.old_exams.select { |e| e.unarchived? }

    number_of_filler_exams = 37 - @unarchived_exams.count
    if number_of_filler_exams < 0
      flash[:warning] = 'Es können nicht alle Prüfungen auf eine Seite gedruckt werden. Bitte einige Klausuren archivieren oder auslaugern.'
    end

    filler_exam = OldExam.new
    while number_of_filler_exams > 0
      @unarchived_exams << filler_exam
      number_of_filler_exams -= 1
    end

    render layout: "print"
  end

  private
  def old_folder_params
    params.require(:old_folder).permit(:title, :contentType, :color, :area)
  end

end
