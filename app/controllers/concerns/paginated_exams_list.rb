module PaginatedExamsList
  extend ActiveSupport::Concern
  include Searchable

  def paginated_exams_list
    clear_search_on_reset

    @old_exams = OldExam
                     .search(params[:search])
                     .paginate(:page => params[:page], :per_page => 50)
  end
end