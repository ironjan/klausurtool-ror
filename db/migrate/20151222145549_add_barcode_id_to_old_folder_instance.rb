class AddBarcodeIdToOldFolderInstance < ActiveRecord::Migration
  def change
    add_column :old_folder_instances, :barcodeId, :string
  end
end
