class AddUnarchivedToOldExams < ActiveRecord::Migration #:nodoc:
  def change
  	    add_column :old_exams, :unarchived, :boolean, :default => true
  end
end
