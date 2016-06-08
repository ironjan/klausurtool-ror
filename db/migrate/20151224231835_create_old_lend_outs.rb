class CreateOldLendOuts < ActiveRecord::Migration #:nodoc:
  def change
    create_table :old_lend_outs do |t|
      t.string :deposit
      t.string :student
      t.string :imt
      t.string :lender
      t.string :receiver
      t.datetime :lendingTime
      t.datetime :receivingTime

      t.timestamps null: false
    end
  end
end
