class OldFolderInstancesController < ApplicationController
	layout 'admin'

	def index
		@old_folder_instances = OldFolderInstance.all
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
		@old_folder_instance.barcodeId = "#{format('%03d', @old_folder_instance.old_folder_id)}#{@old_folder_instance.number}"
		@old_folder_instance.save
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
		@old_folder_instance.destroy
		redirect_to @old_folder
	end


	private
	def old_folder_instance_params
		params.require(:old_folder_instance).permit(:number)		
	end

end