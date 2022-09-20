# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:user)).to be_valid
    end
    it "is not valid without a first name" do
      expect(build(:user, first_name: nil)).to_not be_valid
    end
    it "is not valid without a second name" do
      expect(build(:user, second_name: nil)).to_not be_valid
    end
    it "is not valid without an email" do
      expect(build(:user, email: nil)).to_not be_valid
    end
    it "is not valid without a password" do
      expect(build(:user, password: nil)).to_not be_valid
    end
  end

  context "associations" do
    it "has many projects" do
      expect(build(:user).projects).to eq([])
    end
    it "has many tasks" do
      expect(build(:user).tasks).to eq([])
    end
    it "has many tags" do
      expect(build(:user).tags).to eq([])
    end
  end

  context "methods" do
    context "full_name" do
      it "returns the correct full name" do
        expect(build(:user, first_name: "John", second_name: "Doe").full_name).to eq("John Doe")
      end
    end
  end
end
