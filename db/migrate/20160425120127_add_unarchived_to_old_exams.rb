class AddUnarchivedToOldExams < ActiveRecord::Migration
  def change
  	    add_column :old_exams, :unarchived, :boolean, :default => true
  end
end
