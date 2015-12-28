class OldExamsController < ApplicationController
	layout "admin"

	def create
		@old_folder = OldFolder.find(params[:old_folder_id])
		@old_exam = @old_folder.old_exams.create(old_exam_params)
		@old_exam.save
		redirect_to @old_folder
	end

	def destroy
		@old_folder = OldFolder.find(params[:old_folder_id])
		@old_exam = @old_folder.old_exams.find(params[:id])
		@old_exam.destroy
		redirect_to @old_folder
	end

	def index
		if params[:search]
			@old_exams = OldExam.search(params[:search])
		else
			@old_exams = OldExam.all
		end
	end

	def show
		@old_exam = OldExam.find(params[:id])
	end

	# def new
	# 	# FIXME? 
	# 	@old_exam = OldExam.new
	# end

	def edit
		@old_exam = OldExam.find(params[:id])
	end


	def update
		if params.has_key?(:old_folder_id)
			@old_folder = OldFolder.find(params[:old_folder_id])
			@old_exam = @old_folder.old_exams.find(params[:id])
			@old_exam.update(old_exam_params)
			redirect_to @old_folder
		else
			@old_exam = OldExam.find(params[:id])
			if @old_exam.update(old_exam_params)
				redirect_to @old_exam
			else
				render 'edit'
			end
		end
	end


	private
	def old_exam_params
		params.require(:old_exam).permit(:title, :examiners, :date)
	end

end