class OldFoldersController < ApplicationController
	layout 'admin'

	def index
	  if params[:reset]
      redirect_to old_folders_path
    end

    if params[:search].nil? or params[:search].empty?
			@old_folders = OldFolder.all
    else
			@old_folders = OldFolder.search("%#{params[:search]}%")
    end
	end

	def list_broken_encodings
		regex = /.*(Â¦|Â¨|\?|Â´|Â¸|Ã€|Ã|Ã‚|Ãƒ|Ã„|Ã…|Ã†|Ã‡|Ãˆ|Ã‰|ÃŠ|Ã‹|ÃŒ|Ã|ÃŽ|Ã|Ã‘|Ã’|Ã“|Ã”|Ã•|Ã–|Ã˜|Ã™|Ãš|Ã›|Ãœ|Ã|Ãž|ÃŸ|Ã |Ã¡|Ã¢|Ã£|Ã¤|Ã¥|Ã¦|Ã§|Ã¨|Ã©|Ãª|Ã«|Ã¬|Ã­|Ã®|Ã¯|Ã°|Ã±|Ã²|Ã³|Ã´|Ãµ|Ã¶|Ã¸|Ã¹|Ãº|Ã»|Ã½|Ã¾|Ã¿).*/
		@old_exams = OldExam.all
		Rails.logger.debug("Found #{@old_exams.count} exams")
		@old_exams = @old_exams
										 .select {|exam| exam.examiners[regex] or exam.title[regex]}
		Rails.logger.debug("Filtered down to #{@old_exams.count} exams with broken encodings")
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
			numberOfFolderInstances = params[:count].gsub(/\D/, '').to_i
			Rails.logger.debug("Loop values: #{i}, #{numberOfFolderInstances}")
			until i > numberOfFolderInstances
				barcodeId = "#{format('%03d', @old_folder.id)}#{i}"
				Rails.logger.debug("Trying to create instance #{i} with barcodeId #{barcodeId}")
				folder_instance_params = ActionController::Parameters.new({
					old_folder_instance: {
						number:    i,
						barcodeId: barcodeId
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
