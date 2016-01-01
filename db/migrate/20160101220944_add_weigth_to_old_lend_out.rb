class AddWeigthToOldLendOut < ActiveRecord::Migration
  def change
    add_column :old_lend_outs, :weigth, :integer
  end
end
