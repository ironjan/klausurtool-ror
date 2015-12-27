class AddOldLendOutRefToOldFolderInstances < ActiveRecord::Migration
  def change
    add_reference :old_folder_instances, :old_lend_out, index: true, foreign_key: true
  end
end
