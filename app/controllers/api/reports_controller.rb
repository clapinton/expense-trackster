class Api::ReportsController < ApplicationController

  before_action :require_signed_in

  def create
    puts("filters are #{report_params}")
    new_report = Report.new(created_by: current_user.id)
    @reported_expenses =
      new_report.get_expenses_from_filters(current_user.id, report_params)
    if new_report.save
      render "api/reports/show"
    else
      render json: new_report.errors.full_messages, status: 422
    end
  end

  private

  def report_params
    params.require(:filters).permit(:from_date, :to_date)
  end

  def is_correct_owner(expense)
    current_user.id === expense.owner_id
  end  

end
