require 'faker'

FactoryGirl.define do
  factory :old_folder_instance do |o|
    o.number { Faker::Number.between(1, 9) }
    o.old_folder_id { Faker::Number.between(100, 999) }
    o.barcodeId { o.update_and_get_barcodeId }
  end
end