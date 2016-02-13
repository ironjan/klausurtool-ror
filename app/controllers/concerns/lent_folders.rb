module LentFolders
	extend ActiveSupport::Concern

	def lent
		@old_lend_outs = OldLendOut.all
	end

	def history
		@archived_lend_outs = ArchivedOldLendOut
		.order(:receivingTime => :desc)
		.paginate(:page => params[:page], :per_page => 50)
	end
end