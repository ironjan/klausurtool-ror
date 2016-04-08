require 'rails_helper'

describe AusleiheHelper do

  describe "string_to_barcode_id" do
    it "returns a valid 4-digit barcode_id as is" do
      expect(string_to_barcode_id('1231')).to eq('1231')
    end

    it "shortens a valid 8-digit barcode_id to a 4-digit barcode_id" do
      expect(string_to_barcode_id('00012317')).to eq('1231')
    end

    it "modifies a 5-7 digits barcode_id to a 4-digit barcode_id" do
      expect(string_to_barcode_id('0001231')).to eq('1231')
    end

    it "does not modigy a barcode_id with length <4" do
      expect(string_to_barcode_id('123')).to eq('123')
    end

    it "it shortens a string longer than 8 digits to a 4-digit barcode_id" do
      expect(string_to_barcode_id('00012317554')).to eq('1231')
    end

  end
end