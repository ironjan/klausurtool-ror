class AdminLendoutsController < ApplicationController
  layout 'admin'

  def lent
    @old_lend_outs = OldLendOut.where(:receiver => nil)
  end

  def history
    @archived_lend_outs = ArchivedOldLendOut.paginate(:page => params[:page], :per_page => 50)
  end
end