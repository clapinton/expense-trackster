# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  is_admin        :boolean          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'
begin
  User
rescue
  User = nil
end

RSpec.describe User, :type => :model do

  describe "validates input params presence" do
    it "validates email presence" do
      user = User.new(password: "123456", is_admin: false)
      expect(user).not_to be_valid
    end
    
    it "validates password presence" do
      user = User.new(email: "admin@domain.com", is_admin: false)
      expect(user).not_to be_valid
    end

    it "validates admin flag presence" do
      user = User.new(email: "admin@domain.com", password: "123456")
      expect(user).not_to be_valid
    end

    it "accepts a valid user" do
      user = User.new(email: "admin@domain.com", password: "123456", is_admin: false)
      expect(user).to be_valid
    end

  end

  describe "password encryption" do

    it "validates password length" do
      user = User.new(email: "admin@domain.com",  password: "123", is_admin: false)
      expect(user).not_to be_valid
    end

    it "does not save passwords to the database" do
      User.create!(email: "admin@domain.com",  password: "abcdef", is_admin: false)
      user = User.find_by_email("admin@domain.com")
      expect(user.password).not_to be("abcdef")
    end

    it "encrypts the password using BCrypt" do
      expect(BCrypt::Password).to receive(:create)
      User.new(email: "admin@domain.com",  password: "abcdef")
    end
  end

  describe "session token" do
    it "assigns a session_token if one is not given" do
      admin = User.create(email: "admin@domain.com",  password: "abcdef", is_admin: false)
      expect(admin.session_token).not_to be_nil
    end
  end

  describe "finding by credentials" do

    before(:each) do
      admin = User.create!(email: "admin@domain.com",  password: "abcdef", is_admin: false)
    end

    it "finds a user with valid credentials" do
      found_admin = User.find_by_credentials("admin@domain.com", "abcdef")
      expect(found_admin).not_to be_nil
    end

    it "does not find a user with invalid password" do
      found_admin = User.find_by_credentials("admin@domain.com", "123456")
      expect(found_admin).to be_nil
    end

    it "does not find a user with invalid email" do
      found_admin = User.find_by_credentials("user@domain.com", "abcdef")
      expect(found_admin).to be_nil
    end
  end

  it { should have_many(:expenses) }

end
