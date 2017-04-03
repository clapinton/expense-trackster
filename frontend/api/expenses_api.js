export const getAllExpenses = (success, error) => {
  $.ajax({
    method: "GET",
    url: "api/expenses",
    success,
    error
  })
}

export const getExpense = (expense, success, error) => {
  $.ajax({
    method: "GET",
    url: `api/expenses/${expense.id}`,
    data: {expense},
    success,
    error
  })
}

export const createExpense = (expense, success, error) => {
  $.ajax({
    method: "POST",
    url: "api/expenses",
    data: {expense},
    success,
    error
  })
}

export const editExpense = (expense, success, error) => {
  $.ajax({
    method: "PATCH",
    url: `api/expenses/${expense.id}`,
    data: {expense},
    success,
    error
  })
}


export const deleteExpense = (expense, success, error) => {
  $.ajax({
    method: "DELETE",
    url: `api/expenses/${expense.id}`,
    data: {expense},
    success,
    error
  })
}

export const createReport = (filters, success, error) => {
  $.ajax({
    method: "POST",
    url: "api/reports",
    data: {filters},
    success,
    error
  })
}