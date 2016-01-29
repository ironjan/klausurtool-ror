require 'faker'

FactoryGirl.define do
  factory :old_folder_instance do |o|
    old_folder = FactoryGirl.build(:old_folder)

    o.number {Faker::Number.between(1, 9) }
    o.old_folder_id old_folder.id
    o.barcodeId {o.update_and_get_barcodeId}
  end
end