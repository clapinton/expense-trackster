# == Schema Information
#
# Table name: expenses
#
#  id          :integer          not null, primary key
#  owner_id    :integer          not null
#  datetime    :datetime         not null
#  weeknum     :integer          not null
#  amount      :float            not null
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :expense do
    
  end
end
