class OldLendOutsController < ApplicationController
	def index
		@old_lend_outs = OldLendOut.all
	end
end