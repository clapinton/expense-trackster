json.array!(@expenses) do |expense|
  json.set! expense.datetime do 
    json.set! expense.id do
      json.extract! expense, :amount, :description, :owner_id
    end
  end
end