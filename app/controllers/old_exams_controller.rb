class OldExamsController < ApplicationController
  include PaginatedExamsList

  layout 'admin'

  def create
    @existing_titles = OldExam.existing_titles
    @existing_examiners = OldExam.existing_examiners


    @old_folder = OldFolder.find_by_id(params[:old_folder_id])

    if @old_folder.nil?
      flash[:alert] = 'Ordner nicht gefunden.'
      render :new and return
    end

    @old_exam = @old_folder.old_exams.create(old_exam_params)
    if @old_exam.save
      redirect_to @old_folder
    else
      render :new
    end
  end

  def destroy
    @old_folder = OldFolder.find(params[:old_folder_id])
    @old_exam = @old_folder.old_exams.find(params[:id])
    @old_exam.destroy
    redirect_to @old_folder
  end


  def index
    paginated_exams_list
  end

  def show
    @old_exam = OldExam.find(params[:id])
    add_date_warning
  end

  def new
    old_folder_id = params[:old_folder_id]

    if old_folder_id.nil?
      flash[:alert] = 'Kein Ordner angegeben.'
      return
    end

    @old_folder = OldFolder.find_by_id(old_folder_id)

    if @old_folder.nil?
      flash[:alert] = 'Ordner nicht gefunden.'
    end

    @old_exam = OldExam.new
    @existing_titles = OldExam.existing_titles
    @existing_examiners = OldExam.existing_examiners
  end

  def edit
    @old_exam = OldExam.find(params[:id])
    add_date_warning
  end


  def update
    if params.has_key?(:old_folder_id)
      @old_folder = OldFolder.find(params[:old_folder_id])
      @old_exam = @old_folder.old_exams.find(params[:id])
      @old_exam.update(old_exam_params)
      redirect_to @old_folder
    else
      flash[:warning] = 'Ordner wurde nicht übergeben.'
      @old_exam = OldExam.new
      render 'edit'
    end
  end


  private
  def old_exam_params
    params.require(:old_exam).permit(:title, :examiners, :date)
  end

end