class CreateOldExams < ActiveRecord::Migration #:nodoc:
  def change
    create_table :old_exams do |t|
      t.string :title
      t.string :examiners
      t.date :date
      t.references :old_folder, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
