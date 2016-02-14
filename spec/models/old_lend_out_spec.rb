require 'rails_helper'

describe OldLendOut do
	describe "'s factory" do
		it "is a valid factory" do
			expect(FactoryGirl.build(:old_lend_out)).to be_valid
		end
	end

	describe "'s validations" do
		it "is invalid without imt login" do
			expect(FactoryGirl.build(:old_lend_out, imt: nil)).to_not be_valid
		end
		
		it "is invalid without lender" do
			expect(FactoryGirl.build(:old_lend_out, lender: nil)).to_not be_valid
		end
		
		it "is invalid without lendingTime" do
			expect(FactoryGirl.build(:old_lend_out, lendingTime: nil)).to_not be_valid
		end
		
		it "is invalid without deposit" do
			expect(FactoryGirl.build(:old_lend_out, deposit: nil)).to_not be_valid
		end
		
		it "is invalid without weigth" do
			expect(FactoryGirl.build(:old_lend_out, weigth: nil)).to_not be_valid
		end

		it "is invalid with a weigth <1g" do
			expect(FactoryGirl.build(:old_lend_out, weigth: 0)).to_not be_valid
			expect(FactoryGirl.build(:old_lend_out, weigth: -1)).to_not be_valid
		end
		
		it "is invalid with only receiver" do
			expect(FactoryGirl.build(:old_lend_out, receiver: "receiver", receivingTime: nil)).to_not be_valid
		end
		
		it "is invalid with only receivingTime" do
			expect(FactoryGirl.build(:old_lend_out, receiver: nil, receivingTime: Time.new)).to_not be_valid
		end
		
		it "is invalid when all required fields are set" do
		  # values are set in factory
		  expect(FactoryGirl.build(:old_lend_out)).to be_valid
		end

		it "is invalid when all required fields and both receiver and receivingTime are set" do
			# other values are set in factory
			expect(FactoryGirl.build(:old_lend_out, receiver: "receiver", receivingTime: Time.new)).to be_valid
		end

	end
end
