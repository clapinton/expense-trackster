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
  let(:expense_1) { Expense.create!(amount: "123.45", owner_id: admin.id, datetime: '1414-12-14T14:12:00.000Z', description: 'Created by an admin') }
  let(:expense_2) { Expense.create!(amount: "678.90", owner_id: user.id, datetime: '1414-12-14T14:12:00.000Z', description: 'Created by a user') }

  describe "GET show" do

    context "when logged in as an admin" do
      
      before do
        allow(controller).to receive(:current_user) { admin }
      end

      it "as an admin, can view their own expense" do
        get :show, {:format => :json, :id => expense_1.id}
        expect(response).to have_http_status(200)
        hash_body = JSON.parse(response.body)
        expect(hash_body).to match({
          "id" => expense_1.id,
          "amount" => '123.45',
          "datetime" => '1414-12-14T14:12',
          "description" => 'Created by an admin',
          "owner_id" => admin.id
        })
      end

      it "as an admin, can view another user's expense" do
        get :show, {:format => :json, :id => expense_2.id}
        expect(response).to have_http_status(200)
        hash_body = JSON.parse(response.body)
        expect(hash_body).to match({
          "id" => expense_2.id,
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

      it "as a user, can view their own expense" do
        get :show, {:format => :json, :id => expense_2.id}
        expect(response).to have_http_status(200)
        hash_body = JSON.parse(response.body)
        expect(hash_body).to match({
          "id" => expense_2.id,
          "amount" => '678.90',
          "datetime" => '1414-12-14T14:12',
          "description" => 'Created by a user',
          "owner_id" => user.id
        })
      end

      it "as a user, can not view another user's expense" do
        get :show, {:format => :json, :id => expense_1.id}
        expect(response).to have_http_status(403)
      end
    end
    
  end
end