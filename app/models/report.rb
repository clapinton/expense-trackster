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
    filters = append_time_of_day(filters)
    puts("filter from is #{filters['from_date']}")
    sqlQuery = (<<-SQL)
      SELECT weeknum, SUM(amount) AS sum_amount FROM expenses
      WHERE owner_id = '#{user_id}'
      AND datetime BETWEEN '#{filters["from_date"]}' AND '#{filters["to_date"]}'
      GROUP BY weeknum
      ORDER BY weeknum;
    SQL
    Expense.find_by_sql(sqlQuery)
  end

  private

  def append_time_of_day(filters)
    # The filters should go from 00:00:00 on the from_date to 23:59:59 on the to_date. Therefore, we:

    # • create new Time instance from from_date using UTC time zone (Time.gm).
    # • 00:00:00 gets automatically appended to new_from
    new_from = Time.gm(*filters['from_date'].split("-"))
    filters['from_date'] = new_from

    # • create new Time instance from to_date using UTC time zone (Time.gm).
    # • add 23:59:59 to the new_to
    new_to = Time.gm(*filters['to_date'].split("-"))
    new_to += (60*60*23 + 60*59 + 59)
    filters['to_date'] = new_to

    filters
  end

end
