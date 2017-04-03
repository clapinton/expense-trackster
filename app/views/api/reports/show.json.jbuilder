json.array!(@reported_expenses) do |expense|
  json.extract! expense, :sum_amount, :weeknum
end