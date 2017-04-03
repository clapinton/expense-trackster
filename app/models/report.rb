# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  created_by :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ActiveRecord::Base

  def get_expenses_from_filters(user_id, filters)
    sqlQuery = (<<-SQL)
      SELECT weeknum, SUM(amount) AS sum_amount FROM expenses
      WHERE owner_id = '#{user_id}'
      AND datetime BETWEEN '#{filters["from_date"]}' AND '#{filters["to_date"]}'
      GROUP BY weeknum
      ORDER BY weeknum;
    SQL
    Expense.find_by_sql(sqlQuery)
  end


end
