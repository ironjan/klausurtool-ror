class AdminLendoutsController < ApplicationController
  layout "admin"

  def lent
    @old_lend_outs = OldLendOut.where(:receiver => nil)
  end

end