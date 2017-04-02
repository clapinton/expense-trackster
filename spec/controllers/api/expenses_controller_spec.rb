require 'rails_helper'

# So specs will run and not throw scary errors before ExpensesController is implemented
begin
  ExpensesController
rescue
  ExpensesController = nil
end

RSpec.describe Api::ExpensesController, type: :controller do

  render_views

  let(:admin) { User.create!(email: "admin@domain.com",  password: "abcdef", is_admin: true) }
  let(:user) { User.create!(email: "user@domain.com",  password: "abcdef", is_admin: false) }
  let(:expense_admin) { Expense.create!(amount: "123.45", owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'Created by an admin') }
  let(:expense_user) { Expense.create!(amount: "678.90", owner_id: user.id, datetime: '1414-12-14T14:12:00.000Z', description: 'Created by a user') }

  describe "GET index" do

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
end