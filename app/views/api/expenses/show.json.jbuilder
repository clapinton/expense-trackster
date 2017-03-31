json.id @expense.id
json.amount @expense.amount
json.datetime @expense.datetime.strftime("%Y-%m-%dT%H:%m")
json.description @expense.description
json.owner_id @expense.owner_id