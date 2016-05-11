# Provides CRUD actions for folder instances
class OldFolderInstancesController < ApplicationController
  include PaginatedFolderInstanceList

  layout 'admin'

  def index
    paginated_folder_instance_list
  end

  def show
    @old_folder_instance = OldFolderInstance.find(params[:id])
  end

  def new
    @old_folder_instance = OldFolderInstance.new
  end

  def edit
    @old_folder_instance = OldFolderInstance.find(params[:id])
  end

  def create
    @old_folder = OldFolder.find(params[:old_folder_id])
    @old_folder_instance = @old_folder.old_folder_instances.create(old_folder_instance_params)
    @old_folder_instance.update_and_get_barcodeId

    if @old_folder_instance.save
      flash[:notice] = 'Exemplar wurde angelegt.'
    else
      messages = []
      messages << 'Exemplar konnte nicht erstellt werden.'
      @old_folder_instance.errors.full_messages.each do |msg|
        messages << msg
      end
      flash[:alert] = messages.join(' ')
    end

    redirect_to old_folder_path(@old_folder)
  end

  def update
    @old_folder_instance = OldFolderInstance.find(params[:id])

    if @old_folder_instance.update(old_folder_instance_params)
      redirect_to @old_folder_instance
    else
      render 'edit'
    end
  end

  def destroy
    @old_folder = OldFolder.find(params[:old_folder_id])
    @old_folder_instance = @old_folder.old_folder_instances.find(params[:id])

    instance_is_lent = @old_folder_instance.old_lend_out.nil?
    unless instance_is_lent
      flash[:alert] = 'Ordner-Instanz ist verliehen und kann nicht gelöscht werden.'
      redirect_to @old_folder and return
    end

    @old_folder_instance.destroy
    redirect_to @old_folder
  end


  private
  def old_folder_instance_params
    params.require(:old_folder_instance).permit(:number)
  end

end