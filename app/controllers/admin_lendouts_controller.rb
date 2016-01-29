class AdminLendoutsController < ApplicationController
  layout 'admin'

  def lent
    @old_lend_outs = OldLendOut.all
  end

  def history
    @archived_lend_outs = ArchivedOldLendOutArchivedOldLendOut
                              .order(:receivingTime => :desc)
                              .paginate(:page => params[:page], :per_page => 50)
  end
end