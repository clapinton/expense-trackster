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

require 'rails_helper'
begin
  Expense
rescue
  Expense = nil
end

RSpec.describe Expense, :type => :model do

  describe "validates input params presence" do
    it "validates amount presence" do
      expense = Expense.new(owner_id: 1, datetime: '2017-04-03T14:04:00.000Z', description: 'Test expense', weeknum: 201714)
      expect(expense).not_to be_valid
    end

    it "validates amount digits" do
      expense_many_digits = Expense.new(amount: '123.456', owner_id: 1, datetime: '2017-04-03T14:04:00.000Z', description: 'Test expense', weeknum: 201714)
      expect(expense_many_digits).not_to be_valid
      expense_few_digits = Expense.new(amount: '123.4', owner_id: 1, datetime: '2017-04-03T14:04:00.000Z', description: 'Test expense', weeknum: 201714)
      expect(expense_few_digits).to be_valid
      expense_no_digits = Expense.new(amount: '123', owner_id: 1, datetime: '2017-04-03T14:04:00.000Z', description: 'Test expense', weeknum: 201714)
      expect(expense_no_digits).to be_valid
    end

    it "validates owner presence" do
      expense = Expense.new(amount: "123.45", datetime: '2017-04-03T14:04:00.000Z', description: 'Test expense', weeknum: 201714)
      expect(expense).not_to be_valid
    end

    it "validates datetime presence" do
      expense = Expense.new(amount: "123.45", owner_id: 1, description: 'Test expense', weeknum: 201714)
      expect(expense).not_to be_valid
    end

    it "validates description presence" do
      expense = Expense.new(amount: "123.45", owner_id: 1, datetime: '2017-04-03T14:04:00.000Z')
      expect(expense).not_to be_valid
    end

    it "accepts a valid expense" do
      expense = Expense.new(amount: "123.45", owner_id: 1, datetime: '2017-04-03T14:04:00.000Z', description: 'Text expense')
      expect(expense).to be_valid
    end

  end

  it { should belong_to(:owner) }

end
