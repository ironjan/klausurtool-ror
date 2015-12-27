class CreateOldLendOuts < ActiveRecord::Migration
  def change
    create_table :old_lend_outs do |t|
      t.string :deposit
      t.string :student
      t.string :imt
      t.string :lender
      t.string :receiver
      t.datetime :lendingTime
      t.datetime :receivingTime
      t.references :old_folder_instances, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
