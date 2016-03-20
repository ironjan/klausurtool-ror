module Internal
  module Admin
    class LendoutsController < ApplicationController

      include LentFolders, LendingArchive

      layout 'admin'

    end
  end
end