class OldExamsController < ApplicationController

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
		@old_exams = OldExam.all
	end

	def show
		@old_exam = OldExam.find(params[:id])
	end

	# def new
	# 	# FIXME? 
	# 	@old_exam = OldExam.new
	# end

	# def edit
	# 	@old_exam = OldExam.find(params[:id])
	# end


	# def update
	# 	@old_exam = OldExam.find(params[:id])

	# 	if @old_exam.update
	# 		redirect_to @old_exam
	# 	else
	# 		render 'edit'
	# 	end
	# end


	private
	def old_exam_params
		params.require(:old_exam).permit(:title, :examiners, :date)
	end

end