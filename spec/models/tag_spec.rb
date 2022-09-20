# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tag, type: :model do
  let(:test_user) { create(:user) }
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:tag, user: test_user)).to be_valid
    end
    it "is not valid without a name" do
      expect(build(:tag, user: test_user, title: nil)).to_not be_valid
    end
    it "is not valid without a user" do
      expect(build(:tag, user: nil)).to_not be_valid
    end
  end

  context "associations" do
    test_tag = nil
    before :each do
      test_tag = FactoryBot.create(:tag, user: test_user)
    end

    it "has many tasks" do
      expect(test_tag.tasks).to eq([])
    end
    it "belongs to a user" do
      expect(test_tag.user).to eq(test_user)
    end

    after :each do
      test_tag.destroy!
    end
  end
end
