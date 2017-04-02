require 'rails_helper'

# So specs will run and not throw scary errors before UsersController is implemented
begin
  UsersController
rescue
  UsersController = nil
end

RSpec.describe Api::UsersController, type: :controller do

  set_up_users_and_expenses

  describe "GET show" do
    
    context "when not logged in" do
      it "returns 403" do
        get :show, {id: admin.id, :format => :json}
        expect(response).to have_http_status(403)
      end      
    end

    context "when logged in as an admin" do
      
      before do
        allow(controller).to receive(:current_user) { admin }
      end

      it "allows admin to view their own info" do
        get :show, {id: admin.id, :format => :json}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to eq(admin.id)
      end      

      it "does not allow admin to view another user's info" do
        get :show, {id: user.id, :format => :json}
        expect(response).to have_http_status(403)
      end      
    end

    context "when logged in as a user" do
      
      before do
        allow(controller).to receive(:current_user) { user }
      end

      it "allows user to view their own info" do
        get :show, {id: user.id, :format => :json}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to eq(user.id)
      end      

      it "does not allow user to view another user's info" do
        get :show, {id: admin.id, :format => :json}
        expect(response).to have_http_status(403)
      end      
    end

  end

  describe "POST" do

    context "with correct parameters" do

      it "allows user to be created with valid parameters and render show" do
        new_user = {email: "user2@domain.com",  password: "abcdef", is_admin: false}
        post :create, {user: new_user, format: :json}
        expect(response).to have_http_status(200)
        expect(response).to render_template("show")
        new_created_user = User.find_by_email("user2@domain.com")
        expect(new_created_user).to_not be_nil
        expect(new_created_user.is_admin).to be(false)
      end

      it "allows admin to be created with valid parameters and render show" do
        new_admin = {email: "admin2@domain.com",  password: "abcdef", is_admin: true}
        post :create, {user: new_admin, format: :json}
        expect(response).to have_http_status(200)
        expect(response).to render_template("show")
        new_created_user = User.find_by_email("admin2@domain.com")
        expect(new_created_user).to_not be_nil
        expect(new_created_user.is_admin).to be(true)
      end

      it "logs in the newly created user" do
        new_user = {email: "user2@domain.com",  password: "abcdef", is_admin: false}
        post :create, {user: new_user, format: :json}
        expect(response).to have_http_status(200)
        new_created_user = User.find_by_email("user2@domain.com")
        expect(session[:session_token]).to eq(new_created_user.session_token)
      end

    end

    it "does not allow duplicate users" do
      new_user = {email: "user2@domain.com",  password: "abcdef", is_admin: false}
      post :create, {user: new_user, format: :json}
      post :create, {user: new_user, format: :json}
      expect(response).to have_http_status(401)      
    end

    it "does not create user with invalid parameters" do
      new_user = {password: "abcdef", is_admin: false}
      post :create, {user: new_user, format: :json}
      expect(response).to have_http_status(422)
    end
  end

end
