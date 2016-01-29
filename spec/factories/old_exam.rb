require 'faker'

FactoryGirl.define do
  factory :old_exam do |o|
    o.old_folder_id 1
    o.date { Faker::Date.birthday}
    o.title { Faker::Name.name }
    o.examiners { Faker::Name.name }
  end
end