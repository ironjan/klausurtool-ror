class CreateOldFolders < ActiveRecord::Migration
  def change
    create_table :old_folders do |t|
      t.string :title
      t.string :contentType
      t.string :color
      t.string :area

      t.timestamps null: false
    end
  end
end
