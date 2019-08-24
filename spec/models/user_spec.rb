require 'rails_helper'

RSpec.describe User, type: :model do
	let(:company1) { create(:company, name: "Company 1")} 
  subject do
  	described_class.new(
  		email: "task@company1.com",
  		password: "password",
  		password_confirmation: "password",
  		company_id: company1.id,
  		type: "TaskAdmin"
  	)
  end

  context "attributes are valid" do
	  it "is valid" do
	  	expect(subject).to be_valid
	  end
	end

  context "email is not present" do
  	before(:each) do
  		subject.email = ""
  	end

	  it "is not valid" do
	  	expect(subject).to_not be_valid
	  end

	  it "adds the correct error" do
	  	subject.save
	  	expect(subject.errors[:email][0]).to eq "can't be blank"
	  end
	end

  context "email is not unique" do
  	before(:each) do
	  	user2 = described_class.create(
	  		email: "task@company1.com",
	  		password: "password",
	  		password_confirmation: "password",
	  		company_id: company1.id,
	  		type: "TaskAdmin"
	  	)
	  	subject.email = user2.email
  	end

	  it "is not valid" do
	  	expect(subject).to_not be_valid
	  end

	  it "adds the correct error" do
	  	subject.save
	  	expect(subject.errors[:email][0]).to eq "has already been taken"
	  end
	end

  context "password is not present" do
  	before(:each) do
  		subject.password = ""
  	end

	  it "is not valid" do
	  	expect(subject).to_not be_valid
	  end

	  it "adds the correct error" do
	  	subject.save
	  	expect(subject.errors[:password][0]).to eq "can't be blank"
	  end
	end

  context "password doesn't match password_confirmation" do
  	before(:each) do
  		subject.password_confirmation = subject.password.reverse
  	end

	  it "is not valid" do
	  	expect(subject).to_not be_valid
	  end

	  it "adds the correct error" do
	  	subject.save
	  	expect(subject.errors[:password_confirmation][0]).to eq "doesn't match Password"
	  end
	end

  context "type is not included in User::TYPES" do
  	before(:each) do
  		subject.type = "MegaAdmin"
  	end

	  it "is not valid" do
	  	expect(subject).to_not be_valid
	  end

	  it "adds the correct error" do
	  	subject.save
	  	expect(subject.errors[:type][0]).to eq "is not included in the list"
	  end
	end

	context "company_id is not present" do
		context "user is SuperAdmin" do
			it "is valid" do
		  	subject2 = described_class.new(
		  		email: "task@company1.com",
		  		password: "password",
		  		password_confirmation: "password",
		  		company_id: company1.id,
		  		type: "SuperAdmin"
		  	)
				subject2.company_id = nil
		  	expect(subject2).to be_valid
			end
		end

		context "user is TaskAdmin" do
	  	before(:each) do
	  		subject.company_id = nil
	  	end

		  it "is not valid" do
		  	expect(subject).to_not be_valid
		  end

		  it "adds the correct error" do
		  	subject.save
		  	expect(subject.errors[:company][0]).to eq "can't be blank"
		  end
		end
	end
end

