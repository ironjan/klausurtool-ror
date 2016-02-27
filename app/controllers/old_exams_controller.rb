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
    @old_exam.destroy!
    flash[:notice] = "Prüfung erfolgreich gelöscht."
    redirect_to @old_folder
  end


  def index
    paginated_exams_list
  end

  def list_broken
    regex = /.*(ï¿½|Â¦|Â¨|\?|Â´|Â¸|Ã€|Ã|Ã‚|Ãƒ|Ã„|Ã…|Ã†|Ã‡|Ãˆ|Ã‰|ÃŠ|Ã‹|ÃŒ|Ã|ÃŽ|Ã|Ã‘|Ã’|Ã“|Ã”|Ã•|Ã–|Ã˜|Ã™|Ãš|Ã›|Ãœ|Ã|Ãž|ÃŸ|Ã |Ã¡|Ã¢|Ã£|Ã¤|Ã¥|Ã¦|Ã§|Ã¨|Ã©|Ãª|Ã«|Ã¬|Ã­|Ã®|Ã¯|Ã°|Ã±|Ã²|Ã³|Ã´|Ãµ|Ã¶|Ã¸|Ã¹|Ãº|Ã»|Ã½|Ã¾|Ã¿).*/
    @old_exams = OldExam.all
    Rails.logger.debug("Found #{@old_exams.count} exams")
    @old_exams = @old_exams
                     .select { |exam| regex.match(exam.examiners) || regex.match(exam.title) }
    Rails.logger.debug("Filtered down to #{@old_exams.count} exams with broken encodings")
  end

  def show
    @old_exam = OldExam.find(params[:id])
    date_before_type_cast = @old_exam.read_attribute_before_type_cast('date')
    if date_before_type_cast.include? '00'
      flash[:alert] = "Datum in Datenbank (#{date_before_type_cast}) ist fehlerhaft. Bitte durch ein korrektes Datum ersetzen."
    end
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
    if @old_exam.has_invalid_date?
      flash[:alert] = "Datum in Datenbank (#{date_before_type_cast}) ist fehlerhaft. Bitte das Datum korrigieren."
    end
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