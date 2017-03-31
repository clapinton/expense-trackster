# == Schema Information
#
# Table name: expenses
#
#  id          :integer          not null, primary key
#  owner_id    :integer          not null
#  datetime    :datetime         not null
#  amount      :float            not null
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Expense < ActiveRecord::Base

  validates :amount, :datetime, :description, presence: true
  validate :amount_digits

  belongs_to :owner,
    primary_key: :id,
    foreign_key: :owner_id,
    class_name: :User

  private
  def amount_digits
    unless /^[0-9]+(\.[0-9][0-9])?$/.match(amount.to_s)
      errors[:amount] << "has incorrect format. Please make it as $xxx.xx"
    end
  end
    
end
