require 'faker'

FactoryGirl.define do
  factory :old_folder do |o|
    o.id { Faker::Number.number(3) }
    o.title { Faker::Name.name }
    o.contentType 'Klausurordner'
    o.color :black
    o.area 'MMWW'
  end
end