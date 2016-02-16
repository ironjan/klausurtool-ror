class AdminLendoutsController < ApplicationController
  include LentFolders, LendingArchive

  layout 'admin'

end