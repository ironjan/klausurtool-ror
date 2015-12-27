class AusleiheController < ApplicationController

	def index
		if params.has_key?(:folder_list)
			folder_list_to_folderInstances
			@unavailable_folders = @folder_instances.reject { |f| f.old_lend_out.nil?  }
			all_available = @folder_instances.reduce(true) { |result, f| result and f.old_lend_out.nil?  }

			unless all_available
				render index
			else
				redirect_to lending_path(params)
			end
		end
	end

	def lending
		folder_list_to_folderInstances
		@old_lend_out = OldLendOut.new
	end

	private 
	def folder_list_to_folderInstances
		folder_list = params[:folder_list].split(/\r?\n/)
		@folder_instances = folder_list.uniq
										.reject { |f| f.empty? }
										.map { |id| OldFolderInstance.find_by(barcodeId: id) }
		
	end
end
