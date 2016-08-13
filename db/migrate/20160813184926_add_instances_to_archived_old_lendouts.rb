class AddInstancesToArchivedOldLendouts < ActiveRecord::Migration[5.0]
  def change
    change_column :archived_old_lend_outs, :old_folder_instances, :string
  end
end
