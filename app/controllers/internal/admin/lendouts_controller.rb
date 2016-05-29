module Internal #:nodoc:
  module Admin #:nodoc:
    # Provides an index page for the adminstration interface
    class LendoutsController < ApplicationController

      include LentFolders, LendingArchive

      layout 'admin'

    end
  end
end