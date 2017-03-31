class Api::ExpensesController < ApplicationController

  before_action :require_signed_in
  before_action :require_owner_or_admin, only: [:show]
  before_action :require_correct_owner, only: [:update, :destroy]

  def index
    @expenses = Expense.get_all_expenses(current_user)
    render 'api/expenses/index'
  end

  def show
    puts("Hit #show for #{params[:id]}")
    @expense = Expense.find(params[:id])
    if @expense
      render "api/expenses/show"
    else
      render json: ["Expense not found"], status: 404
    end
  end  

  def create
    expense = Expense.new(expense_params)
    expense.owner_id = current_user.id

    if expense.save
      @expenses = Expense.get_all_expenses(current_user)
      render 'api/expenses/index'
    else
      render json: expense.errors.full_messages, status: 422
    end

  end

  def update
    @expense = Expense.find(params[:id])
    if @expense.update(expense_params)
      @expenses = Expense.get_all_expenses(current_user)
      render "api/expenses/index"
    else
      render json: @expense.errors.full_messages, status: 422
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    if @expense
      @expense.delete
      @expenses = Expense.get_all_expenses(current_user)
      render "api/expenses/index"
    else
      render json: ["Expense not found"], status: 422
    end
  end

private

  def expense_params
    params.require(:expense).permit(:amount, :datetime, :description, :owner_id)
  end



end
