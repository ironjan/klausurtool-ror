class CreateOldFolderInstances < ActiveRecord::Migration #:nodoc:
  def change
    create_table :old_folder_instances do |t|
      t.integer :number
      t.references :old_folder, index: true, foreign_key: true
      t.string  :barcodeId, unique: true

      t.timestamps null: false
    end
  end
end
