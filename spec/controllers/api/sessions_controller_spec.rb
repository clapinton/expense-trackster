require 'rails_helper'

# So specs will run and not throw scary errors before SessionsController is implemented
begin
  SessionsController
rescue
  SessionsController = nil
end

RSpec.describe Api::SessionsController, type: :controller do

  before(:each) do
    sign_up_user
  end

  describe "POST #create" do
    context "with invalid credentials" do
      it "returns 404 with a non-existent user" do
        post :create, user: {email: "noone@jaqen.com", password: "abcdef"}, format: :json
        puts(response.status)
        expect(response).to have_http_status(404)
      end

      it "returns 404 with an incorrect password" do
        post :create, user: {email: "user@domain.com", password: "blabla"}
        expect(response).to have_http_status(404)
      end
    end

    context "with valid credentials" do

      it "renders the user info" do
        correct_user = {email: "user@domain.com",  password: "abcdef"}
        post :create, {user: correct_user, format: :json}
        expect(response).to have_http_status(200)
        expect(response).to render_template("show")
      end

      it "logs in the user" do
        correct_user = {email: "user@domain.com",  password: "abcdef"}
        post :create, {user: correct_user, format: :json}
        expect(response).to have_http_status(200)
        logged_in_user = User.find_by_email("user@domain.com")
        expect(session[:session_token]).to eq(logged_in_user.session_token)
      end

    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      post :create, user: {email: "user@domain.com", password: "abcdef"}, format: :json
      some_user = User.find_by_email("user@domain.com")
      @session_token = some_user.session_token
      puts("session token #{@session_token} belongs to user #{some_user.id}")
    end

    it "logs out the current user" do
      delete :destroy, format: :json
      expect(session[:session_token]).to be_nil

      user = User.find_by_email("user@domain.com")
      puts("comparing session token to #{user.id}, which has #{user.session_token}")
      expect(user.session_token).not_to eq(@session_token)
    end
  end
end