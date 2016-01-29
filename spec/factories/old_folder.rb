require 'faker'

FactoryGirl.define do
  factory :old_folder do |o|
    o.id {Faker::IDNumber.valid}
    o.title { Faker::Name.name }
    o.contentType 'Klausurordner'
    o.color :black
    o.area 'MMWW'
  end
end