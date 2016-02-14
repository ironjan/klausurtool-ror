require 'faker'

FactoryGirl.define do
  factory :old_lend_out do |o|
  	o.imt 		  { Faker::Name }
  	o.lender  	  { Faker::Name }
  	o.deposit 	  'Studierendenausweis'
  	o.lendingTime Time.new
  	o.weigth 	  { Faker::Number.number(3) }
  end
end