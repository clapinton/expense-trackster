export const createExpense = (expense, success, error) => {
  $.ajax({
    method: "POST",
    url: "api/expenses",
    data: expense,
    success,
    error
  })
}