class RemoveStudentFromOldLendOut < ActiveRecord::Migration #:nodoc:
  def change
    remove_column :old_lend_outs, :student
  end
end
