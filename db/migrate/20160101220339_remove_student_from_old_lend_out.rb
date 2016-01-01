class RemoveStudentFromOldLendOut < ActiveRecord::Migration
  def change
    remove_column :old_lend_outs, :student
  end
end
