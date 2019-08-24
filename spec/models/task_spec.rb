# == Schema Information
#
# Table name: tasks
#
#  company_id  :integer
#  created_at  :datetime         not null
#  description :text
#  id          :bigint           not null, primary key
#  name        :string
#  price       :decimal(8, 2)
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Task, type: :model do
	let(:company1) { create(:company, name: "Company 1") }
	let(:company2) { create(:company, name: "Company 2") }
  subject do
  	described_class.new(
  		name: "Leaky Faucet",
  		description: "Fix the leaky faucet.",
  		price: 100,
  		company_id: company1.id
  	)
  end

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
  	context "name only conflicts outside of company scope" do
		  it "is valid" do
		  	described_class.create(
		  		name: "Leaky Faucet",
		  		description: "Fix the leaky faucet.",
		  		price: 100,
		  		company_id: company2.id
		  	)

		  	expect(subject).to be_valid
		  end
  	end

  	context "name conflicts within company scope" do
	  	before(:each) do
		  	task2 = described_class.create(
		  		name: "Leaky Faucet",
		  		description: "Fix the leaky faucet.",
		  		price: 100,
		  		company_id: company2.id
		  	)
		  	subject.company_id = task2.company_id
	  		subject.name = task2.name
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

  context "description is not present" do
  	before(:each) do
  		subject.description = ""
  	end

	  it "is not valid" do
	  	expect(subject).to_not be_valid
	  end

	  it "adds the correct error" do
	  	subject.save
	  	expect(subject.errors[:description][0]).to eq "can't be blank"
	  end
	end

  context "price is not present" do
  	before(:each) do
  		subject.price = nil
  	end

	  it "is not valid" do
	  	expect(subject).to_not be_valid
	  end

	  it "adds the correct error" do
	  	subject.save
	  	expect(subject.errors[:price][0]).to eq "can't be blank"
	  end
	end
end

# expect(auction.errors[:bid].first).to eq "must be bigger than the last bid on the auction"
