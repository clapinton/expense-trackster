require 'rails_helper'

# So specs will run and not throw scary errors before ExpensesController is implemented
begin
  ExpensesController
rescue
  ExpensesController = nil
end

RSpec.describe Api::ExpensesController, type: :controller do

  render_views

  set_up_users_and_expenses

  describe "GET index" do

    context "when not logged in" do

      it "returns 403" do
        all_expenses = [expense_admin, expense_user]
        get :index, {:format => :json, expenses: all_expenses}
        expect(response).to have_http_status(403)
      end
    end

    context "when logged in as an admin" do
      
      before do
        allow(controller).to receive(:current_user) { admin }
      end

      it "can view all expenses" do
        all_expenses = [expense_admin, expense_user]
        get :index, {:format => :json, expenses: all_expenses}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to equal(2)
      end

      it "receives all relevant data" do
        get :index, {:format => :json, expenses: [expense_admin]}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response[0]).to include("id", "amount", "datetime", "description", "owner_id")
      end

    end

    context "when logged in as a user" do
      
      before do
        allow(controller).to receive(:current_user) { user }
      end

      it "can only view their own expenses" do
        all_expenses = [expense_admin, expense_user]
        get :index, {:format => :json, expenses: all_expenses}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to equal(1)
      end

      it "receives all relevant data" do
        get :index, {:format => :json, expenses: [expense_user]}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response[0]).to include("id", "amount", "datetime", "description", "owner_id")
      end

    end
  end

  describe "GET show" do

    context "when not logged in" do

      it "returns 403" do
        get :show, {:format => :json, :id => expense_admin.id}
        expect(response).to have_http_status(403)
      end
    end

    context "when logged in as an admin" do
      
      before do
        allow(controller).to receive(:current_user) { admin }
      end

      it "can view their own expense" do
        get :show, {:format => :json, :id => expense_admin.id}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response).to match({
          "id" => expense_admin.id,
          "amount" => '123.45',
          "datetime" => '1414-12-14T14:12',
          "description" => 'Created by an admin',
          "owner_id" => admin.id
        })
      end

      it "can view another user's expense" do
        get :show, {:format => :json, :id => expense_user.id}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response).to match({
          "id" => expense_user.id,
          "amount" => '678.90',
          "datetime" => '1414-12-14T14:12',
          "description" => 'Created by a user',
          "owner_id" => user.id
        })
      end

    end

    context "when logged in as a user" do
      
      before do
        allow(controller).to receive(:current_user) { user }
      end

      it "can view their own expense" do
        get :show, {:format => :json, :id => expense_user.id}
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response).to match({
          "id" => expense_user.id,
          "amount" => '678.90',
          "datetime" => '1414-12-14T14:12',
          "description" => 'Created by a user',
          "owner_id" => user.id
        })
      end

      it "can not view another user's expense" do
        get :show, {:format => :json, :id => expense_admin.id}
        expect(response).to have_http_status(403)
      end
    end
    
  end

  describe "POST" do

    context "when not logged in" do

      it "returns 403" do
        new_expense = {amount: "543.21", owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an admin'}
        post :create, {expense: new_expense, format: :json}
        expect(response).to have_http_status(403)
      end
    end

    context "when logged in as an admin" do

      before do
        allow(controller).to receive(:current_user) { admin }
      end

      it "creates a valid expense and renders #index" do
        new_expense = {amount: "543.21", owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an admin'}
        post :create, {expense: new_expense, format: :json}
        expect(response).to have_http_status(200)
        expect(response).to render_template("index")
      end

      it "fails to create an invalid expense, returning 422" do
        new_expense = {owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an admin'}
        post :create, {expense: new_expense, format: :json}
        expect(response).to have_http_status(422)
      end

    end

    context "when logged in as a user" do

      before do
        allow(controller).to receive(:current_user) { user }
      end

      it "creates a valid expense and renders #index" do
        new_expense = {amount: "98.76", owner_id: user.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by a user'}
        post :create, {expense: new_expense, format: :json}
        expect(response).to have_http_status(200)
        expect(response).to render_template("index")
      end

      it "fails to create an invalid expense, returning 422" do
        new_expense = {owner_id: user.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by a user'}
        post :create, {expense: new_expense, format: :json}
        expect(response).to have_http_status(422)
      end

    end

  end

  describe "PATCH" do

    context "when not logged in" do

      it "returns 403" do
        updated_expense = {amount: "543.21", owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an admin'}
        patch :update, {id: expense_admin.id, expense: updated_expense, format: :json}
        expect(response).to have_http_status(403)
      end
    end

    context "when logged in as an admin" do

      before do
        allow(controller).to receive(:current_user) { admin }
      end

      it "should allow update to own expense" do
        updated_expense = {amount: "543.21", owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an admin'}
        patch :update, {id: expense_admin.id, expense: updated_expense, format: :json}
        expect(response).to have_http_status(200)
        get :show, id: expense_admin.id, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response["amount"]).to eq("543.21")
      end

      it "should not allow update to another user's expense" do
        updated_expense = {amount: "543.21", owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an admin'}
        patch :update, {id: expense_user.id, expense: updated_expense, format: :json}
        expect(response).to have_http_status(403)
      end

      it "should not update with an invalid param" do
        updated_expense = {amount: "543.222", owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an admin'}
        patch :update, {id: expense_admin.id, expense: updated_expense, format: :json}
        expect(response).to have_http_status(422)
      end
    end

    context "when logged in as a user" do

      before do
        allow(controller).to receive(:current_user) { user }
      end

      it "should allow update to own expense" do
        updated_expense = {amount: "98.76", owner_id: user.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an user'}
        patch :update, {id: expense_user.id, expense: updated_expense, format: :json}
        expect(response).to have_http_status(200)
        get :show, id: expense_user.id, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response["amount"]).to eq("98.76")
      end

      it "should not allow update to another user's expense" do
        updated_expense = {amount: "98.76", owner_id: user.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an user'}
        patch :update, {id: expense_admin.id, expense: updated_expense, format: :json}
        expect(response).to have_http_status(403)
      end

      it "should not update with an invalid param" do
        updated_expense = {amount: "98.766", owner_id: user.id, datetime: '1414-12-14T14:12:00.000Z', description: 'POSTed by an user'}
        patch :update, {id: expense_user.id, expense: updated_expense, format: :json}
        expect(response).to have_http_status(422)
      end
    end

  end

end