require 'rails_helper'
begin
  Expense
rescue
  Expense = nil
end

RSpec.describe Expense, :type => :model do

  describe "validates input params presence" do
    it "validates amount presence" do
      expense = Expense.new(owner_id: 1, datetime: '1414-12-14T14:12:00.000Z', description: 'Test expense')
      expect(expense).not_to be_valid
    end

    it "validates amount digits" do
      expense_many_digits = Expense.new(amount: '123.456', owner_id: 1, datetime: '1414-12-14T14:12:00.000Z', description: 'Test expense')
      expect(expense_many_digits).not_to be_valid
      expense_few_digits = Expense.new(amount: '123.4', owner_id: 1, datetime: '1414-12-14T14:12:00.000Z', description: 'Test expense')
      expect(expense_few_digits).not_to be_valid
      expense_no_digits = Expense.new(amount: '123', owner_id: 1, datetime: '1414-12-14T14:12:00.000Z', description: 'Test expense')
      expect(expense_no_digits).to be_valid
    end

    it "validates owner presence" do
      expense = Expense.new(amount: "123.45", datetime: '1414-12-14T14:12:00.000Z', description: 'Test expense')
      expect(expense).not_to be_valid
    end

    it "validates datetime presence" do
      expense = Expense.new(amount: "123.45", owner_id: 1, description: 'Test expense')
      expect(expense).not_to be_valid
    end

    it "validates description presence" do
      expense = Expense.new(amount: "123.45", owner_id: 1, datetime: '1414-12-14T14:12:00.000Z')
      expect(expense).not_to be_valid
    end

    it "accepts a valid expense" do
      expense = Expense.new(amount: "123.45", owner_id: 1, datetime: '1414-12-14T14:12:00.000Z', description: 'Text expense')
      expect(expense).to be_valid
    end

  end

  it { should belong_to(:owner) }

end