class RemoveOldFolderInstancesFromArchivedOldLendouts < ActiveRecord::Migration[5.0]
  def up
    remove_column :archived_old_lend_outs, :old_folder_instances

  end

  def down
    add_column :archived_old_lend_outs, :old_folder_instances, :string
  end
end
