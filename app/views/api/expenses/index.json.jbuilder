json.array!(@expenses) do |expense|
  json.extract! expense, :id, :amount, :datetime, :description, :owner_id
end