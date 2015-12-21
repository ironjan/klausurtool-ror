class CreateExaminers < ActiveRecord::Migration
  def change
    create_table :examiners do |t|
      t.string :name
      t.string :alternativeNames.string

      t.timestamps null: false
    end
  end
end
