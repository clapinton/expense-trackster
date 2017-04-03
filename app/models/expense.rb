# == Schema Information
#
# Table name: expenses
#
#  id          :integer          not null, primary key
#  owner_id    :integer          not null
#  datetime    :datetime         not null
#  weeknum     :integer          not null
#  amount      :string           not null
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Expense < ActiveRecord::Base

  validates :amount, :datetime, :description, :owner_id, presence: true
  validate :amount_digits

  belongs_to :owner,
    primary_key: :id,
    foreign_key: :owner_id,
    class_name: :User

    def self.get_all_expenses(current_user)
      if current_user.is_admin
        return Expense.all
      else
        return current_user.expenses
      end      
    end

    def get_weeknum
      date_year = self.datetime.strftime("%Y")
      week = self.datetime.strftime("%U")
      (date_year+week).to_i
    end

  private
  def amount_digits
    unless /^[0-9]+(\.[0-9][0-9])?$/.match(amount)
      errors[:amount] << "has incorrect format. Please make it as xxx.xx"
    end
  end
    
end
