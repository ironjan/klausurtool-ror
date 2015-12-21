class OldFoldersController < ApplicationController

	def index
		@old_folders = OldFolder.all
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

		if @old_folder.save
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
