class OldExamsController < ApplicationController
  include PaginatedExamsList

  layout 'admin'

  def create
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
    @old_exam.destroy!
    flash[:notice] = "Prüfung erfolgreich gelöscht."
    redirect_to @old_folder
  end


  def index
    paginated_exams_list
  end

  def show
    @old_exam = OldExam.find(params[:id])
  end

  def new
    old_folder_id = params[:old_folder_id]

    if old_folder_id.nil?
      flash[:alert] = 'Kein Ordner beim Anlegen einer neuen Prüfung übergeben.'
      redirect_to old_folders_path and return
    end

    @old_folder = OldFolder.find_by_id(old_folder_id)

    if @old_folder.nil?
      flash[:alert] = 'Ordner nicht gefunden.'
      render :new and return
    end

    @old_exam = @old_folder.old_exams.new
  end

  def edit
    old_folder_id = params[:old_folder_id]

    if old_folder_id.nil?
      flash[:alert] = 'Kein Ordner beim Editieren der Prüfung angegeben.'
      redirect_to old_folders_path and return
    end

    @old_exam = OldExam.find(params[:id])
  end


  def update
    @old_exam = OldExam.find(params[:id])
    if @old_exam.update(old_exam_params)
      redirect_to @old_exam
    else
      render :edit
    end
  end


  private
  def old_exam_params
    params.require(:old_exam).permit(:title, :examiners, :date, :old_folder_id)
  end

end