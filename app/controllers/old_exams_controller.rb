class OldExamsController < ApplicationController
  layout 'admin'

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
    if params[:reset]
      params[:search] = nil
    end

    @old_exams = OldExam
                     .joins(:old_folder)
                     .where('date = ? OR old_exams.title LIKE ? OR old_exams.examiners LIKE ? OR old_folders.title LIKE ?',
                            "#{params[:search]}", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
                     .order('old_folders.title ASC')
                     .paginate(:page => params[:page], :per_page => 50)
  end

  def list_broken_encodings
    regex = /.*(ï¿½|Â¦|Â¨|\?|Â´|Â¸|Ã€|Ã|Ã‚|Ãƒ|Ã„|Ã…|Ã†|Ã‡|Ãˆ|Ã‰|ÃŠ|Ã‹|ÃŒ|Ã|ÃŽ|Ã|Ã‘|Ã’|Ã“|Ã”|Ã•|Ã–|Ã˜|Ã™|Ãš|Ã›|Ãœ|Ã|Ãž|ÃŸ|Ã |Ã¡|Ã¢|Ã£|Ã¤|Ã¥|Ã¦|Ã§|Ã¨|Ã©|Ãª|Ã«|Ã¬|Ã­|Ã®|Ã¯|Ã°|Ã±|Ã²|Ã³|Ã´|Ãµ|Ã¶|Ã¸|Ã¹|Ãº|Ã»|Ã½|Ã¾|Ã¿).*/
    @old_exams = OldExam.all
    Rails.logger.debug("Found #{@old_exams.count} exams")
    @old_exams = @old_exams
                     .select { |exam| regex.match(exam.examiners) || regex.match(exam.title) }
    Rails.logger.debug("Filtered down to #{@old_exams.count} exams with broken encodings")
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