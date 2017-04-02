class Api::ExpensesController < ApplicationController

  before_action :require_signed_in

  def index
    @expenses = Expense.get_all_expenses(current_user)
    render 'api/expenses/index'
  end

  def show
    puts("Hit #show for #{params[:id]}")
    @expense = Expense.find(params[:id])
    
    if @expense && is_owner_or_admin(@expense)
      render "api/expenses/show"
    elsif !is_owner_or_admin(@expense)
      render json: ["You do not have permission to view this expense."], status: 403      
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

    if is_correct_owner(@expense)

      if @expense.update(expense_params)
        @expenses = Expense.get_all_expenses(current_user)
        render "api/expenses/index"
      else
        render json: @expense.errors.full_messages, status: 422
      end

    else
      render json: ["You do not have permission to view this expense."], status: 403      
    end

  end

  def destroy
    @expense = Expense.find(params[:id])

    if is_correct_owner(@expense)

      if @expense
        @expense.delete
        @expenses = Expense.get_all_expenses(current_user)
        render "api/expenses/index"
      else
        render json: ["Expense not found"], status: 404
      end

    else
      render json: ["You do not have permission to view this expense."], status: 403
    end

  end

private

  def expense_params
    params.require(:expense).permit(:amount, :datetime, :description, :owner_id)
  end

  def is_owner_or_admin(expense)
    current_user.id === expense.owner_id || current_user.is_admin
  end

  def is_correct_owner(expense)
    current_user.id === expense.owner_id
  end

end
