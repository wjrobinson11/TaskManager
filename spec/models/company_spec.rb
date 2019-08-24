# == Schema Information
#
# Table name: companies
#
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  name       :string
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Company, type: :model do
  subject { described_class.new(name: "Company 1") }

  context "attributes are valid" do
	  it "is valid" do
	  	expect(subject).to be_valid
	  end
	end

  context "name is not present" do
  	before(:each) do
  		subject.name = ""
  	end

	  it "is not valid" do
	  	expect(subject).to_not be_valid
	  end

	  it "adds the correct error" do
	  	subject.save
	  	expect(subject.errors[:name][0]).to eq "can't be blank"
	  end
	end

  context "name is not unique" do
  	before(:each) do
  		company2 = described_class.create(name: "Company 2")
  		subject.name = company2.name
  	end

	  it "is not valid" do
	  	expect(subject).to_not be_valid
	  end

	  it "adds the correct error" do
	  	subject.save
	  	expect(subject.errors[:name][0]).to eq "has already been taken"
	  end
	end
end