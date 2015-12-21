class OldFolderInstancesController < ApplicationController

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
		@old_folder_instance = OldFolderInstance.new(old_folder_instance_params)

		if @old_folder_instance.save
			redirect_to @old_folder_instance
		else
			render 'new'
		end
	end

	def update
		@old_folder_instance = OldFolderInstance.find(params[:id])

		if @old_folder_instance.update
			redirect_to @old_folder_instance
		else
			render 'edit'
		end
	end

	def destroy
		@old_folder_instance = OldFolderInstance.find(params[:id])
		@old_folder_instance.destroy
		redirect_to old_folder_instances_path
	end


	private
	def old_folder_instance_params
		params.require(:old_folder_instance).permit(:number)		
	end

end