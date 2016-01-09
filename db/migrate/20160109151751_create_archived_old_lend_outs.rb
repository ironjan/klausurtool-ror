class CreateArchivedOldLendOuts < ActiveRecord::Migration
  def change
    create_table :archived_old_lend_outs do |t|
      t.string :deposit
      t.string :imt
      t.string :lender
      t.string :receiver
      t.datetime :lendingTime
      t.datetime :receivingTime
      t.integer :weigth
      t.string :old_folder_instances

      t.timestamps null: false
    end

    create_join_table :archived_old_lend_outs, :old_folder_instances
  end
end
