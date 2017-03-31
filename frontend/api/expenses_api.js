export const getAllExpenses = (success, error) => {
  $.ajax({
    method: "GET",
    url: "api/expenses",
    success,
    error
  })
}

export const createExpense = (expense, success, error) => {
  $.ajax({
    method: "POST",
    url: "api/expenses",
    data: expense,
    success,
    error
  })
}