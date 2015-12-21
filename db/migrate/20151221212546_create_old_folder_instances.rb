class CreateOldFolderInstances < ActiveRecord::Migration
  def change
    create_table :old_folder_instances do |t|
      t.integer :number
      t.references :old_folder, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
