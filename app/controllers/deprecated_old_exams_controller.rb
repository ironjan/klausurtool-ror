class DeprecatedOldExamsController < ApplicationController

	def index
		@old_exams = OldExam.all
	end

	def show
		@old_exam = OldExam.find(params[:id])
	end

	def new
		@old_exam = OldExam.new
	end

	def edit
		@old_exam = OldExam.find(params[:id])
	end

	def create
		@old_exam = OldExam.new(old_exam_params)

		if @old_exam.save
			redirect_to @old_exam
		else
			render 'new'
		end
	end

	def update
		@old_exam = OldExam.find(params[:id])

		if @old_exam.update(old_exam_params)
			redirect_to @old_exam
		else
			render 'edit'
		end
	end

	def destroy
		@old_exam = OldExam.find(params[:id])
		@old_exam.destroy
		redirect_to old_exams_path
	end


	private
	def old_exam_params
		params.require(:old_exam).permit(:title, :examiners, :date)
	end

end
