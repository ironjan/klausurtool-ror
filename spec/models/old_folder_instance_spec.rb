require 'rails_helper'

describe OldFolderInstance do

  before(:each) do
    old_folder1 = FactoryGirl.build(:old_folder, title: 'Title')
    old_folder1.save!

    @o1_i1 = FactoryGirl.build(:old_folder_instance, old_folder_id: old_folder1.id, number: 1)
    @o1_i2 = FactoryGirl.build(:old_folder_instance, old_folder_id: old_folder1.id, number: 2)
    @barcodeId1_1 = @o1_i1.update_and_get_barcodeId
    @barcodeId1_2 = @o1_i2.update_and_get_barcodeId

    old_folder2 = FactoryGirl.build(:old_folder, title: 'Another')
    old_folder2.save!
    @o2_i1 = FactoryGirl.build(:old_folder_instance, old_folder_id: old_folder2.id, number: 1)
    @barcodeId2_1 = @o2_i1.update_and_get_barcodeId


    @o1_i1.save!
    @o1_i2.save!
    @o2_i1.save!

    @all_instances = [@o1_i1, @o1_i2, @o2_i1]
  end

  after(:each) do
    @o1_i1.destroy!
    @o1_i2.destroy!
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:old_folder_instance)).to be_valid
  end

  it "is not valid without a number" do
    expect(FactoryGirl.build(:old_folder_instance, number: nil)).to_not be_valid
  end

  it "is not valid with a number <1" do
    expect(FactoryGirl.build(:old_folder_instance, number: -0)).to_not be_valid
    expect(FactoryGirl.build(:old_folder_instance, number: -1)).to_not be_valid
  end


  it "is not valid with a number >9" do
    expect(FactoryGirl.build(:old_folder_instance, number: 10)).to_not be_valid
    expect(FactoryGirl.build(:old_folder_instance, number: 11)).to_not be_valid
  end


  it "is not valid without folder" do
    expect(FactoryGirl.build(:old_folder_instance, old_folder_id: nil)).to_not be_valid
  end


  it "is not valid without barcodeId" do
    expect(FactoryGirl.build(:old_folder_instance, barcodeId: nil)).to_not be_valid
  end


  it "cannot have two folder instances with the same barcodeId" do
    i1 = FactoryGirl.build(:old_folder_instance)
    barcodeId = i1.update_and_get_barcodeId
    i2 = FactoryGirl.build(:old_folder_instance, barcodeId: barcodeId)

    expect {
      i1.save!
      i2.save!
    }.to raise_error
  end

  it "does update its barcodeId correctly" do
    i = FactoryGirl.build(:old_folder_instance)
    expect(i.update_and_get_barcodeId).to eq("#{format('%03d', i.old_folder_id)}#{i.number}")
  end

  it "finds all when searching for nothing" do
    expect(OldFolderInstance.search(nil)).to match_array(@all_instances)
  end

  it "finds all when searching for empty string" do
    expect(OldFolderInstance.search('')).to match_array(@all_instances)
  end

  it "finds nothing when searching for a barcodeId that does not exist" do
    expect(OldFolderInstance.search('0000')).to match_array([])
  end

  it "finds one folder instance when the search by barcodeId matches exactly one folder instance" do
    # This test does not work: even if the web app finds the matches, this test does not O.o
    expect(OldFolderInstance.search(@barcodeId1_1)).to match_array([@o1_i1])
    expect(OldFolderInstance.search(@barcodeId1_2)).to match_array([@o1_i2])
  end

  it "finds two folder instances when the search by barcodeId exactly two folder instances" do
    barcode_prefix = @barcodeId1_1[0..2]
    expect(barcode_prefix).to eq("#{format('%03d', @o1_i1.old_folder_id)}")

    expect(OldFolderInstance.search(barcode_prefix)).to match_array([@o1_i1, @o1_i2])
  end

  it "finds nothing when searching for a title that does not exist" do
    expect(OldFolderInstance.search('Title no match')).to match_array([])
  end

  it "finds one folder instance when the search by title matches exactly one folder instance" do
    expect(OldFolderInstance.search('Another')).to match_array([@o2_i1])
  end

  it "finds two folder instances when the search by title exactly two folder instances" do
    expect(OldFolderInstance.search('Title')).to match_array([@o1_i1, @o1_i2])
  end

end