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

    it "returns 403" do
      new_expense = {amount: "543.21", owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an admin'}
      post :create, {expense: new_expense, format: :json}
      expect(response).to have_http_status(403)
    end
    end


  #   let(:user) { User.create!(email: "admin@domain.com",  password: "abcdef", is_admin: false) }

  #   before do
  #     get :show, {:format => :json, :id => user.id}
  #   end

    
  #   context "with invalid params" do
      
  #     it "validates the presence of the user's email and password" do
  #       post :create, user: {email: "admin@bla.com", password: "", is_admin: false}
  #       expect(response).to have_http_status(422)
  #     end    
  #     it "validates the user uniqueness" do
  #       post :create, user: {email: "admin@bla.com", password: "abcdef", is_admin: false}
  #       # post :create, user: {email: "admin@bla.com", password: "abcdef", is_admin: false}
  #       expect(response).to have_http_status(401)
  #     end    
  #   end
    

    # it "logs in the user" do
    #   post :create, user: {email: "admin@bla.com", password: "password", is_admin: false}
    #   user = User.find_by_email("admin@bla.com")

    #   expect(session[:session_token]).to eq(user.session_token)
    # end


    # it "returns http success" do
    #   expect(response).to have_http_status(200)
    # end

    # it "response with JSON body containing expected User attributes" do
    #   hash_body = nil
    #   expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      # expect(hash_body).to match({
      #   id: article.id,
      #   title: 'Hello World'
      # })
    # end

  # end  

end
