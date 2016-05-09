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


  private
  def old_folder_params
    params.require(:old_folder).permit(:title, :contentType, :color, :area)
  end

end
