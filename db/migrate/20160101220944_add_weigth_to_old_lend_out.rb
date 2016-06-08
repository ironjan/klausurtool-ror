class AddWeigthToOldLendOut < ActiveRecord::Migration #:nodoc:
  def change
    add_column :old_lend_outs, :weigth, :integer
  end
end
