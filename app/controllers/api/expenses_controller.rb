class Api::ExpensesController < ApplicationController

  before_action :require_signed_in!
  before_action :require_owner_or_admin, only: [:show]
  before_action :require_correct_owner, only: [:update, :destroy]

  def index
    @expenses = current_user.expenses
    render 'api/expenses/index'
  end

  def create
    expense = Expense.new(expense_params)
    expense.owner_id = current_user.id

    if expense.save
      @expenses = current_user.expenses
      render 'api/expenses/index'
    else
      render json: expense.errors.full_messages, status: 422
    end

  end

  def expense_params
    params.require(:expense).permit(:amount, :datetime, :description)
  end


end
