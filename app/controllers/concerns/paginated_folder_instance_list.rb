# Provides a paginated list of folder instances
module PaginatedFolderInstanceList
  extend ActiveSupport::Concern
  include Searchable

  def paginated_folder_instance_list
    clear_search_on_reset

    @old_folder_instances = OldFolderInstance
                                .search(params[:search])
                                .paginate(:page => params[:page], :per_page => 50)
  end
end