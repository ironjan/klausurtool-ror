module Internal
  module Admin
    class AdminLendoutsController < ApplicationController
      include LentFolders, LendingArchive

      layout 'admin'

    end
  end
end