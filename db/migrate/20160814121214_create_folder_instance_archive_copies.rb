class CreateFolderInstanceArchiveCopies < ActiveRecord::Migration[5.0]
  def up
    create_table :folder_instance_archive_copies do |t|
      t.string :folder_title
      t.integer :barcode_id
      t.integer :archived_old_lend_out_id

      t.timestamps
    end

  end

  def down

    drop_table :folder_instance_archive_copies
  end
end
