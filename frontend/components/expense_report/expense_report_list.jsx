import React from 'react';

export default function ExpenseReportList({reportedExpenses}) {
  return (
    <table className="expense-report-list">
        <thead>
          <tr>
            <td>Week Start</td>
            <td>Week End</td>
            <td>Expenses Total</td>
          </tr>
        </thead>
        <tbody>
      {reportedExpenses.map( expense => (
        <tr>
          <td>{expense.weeknum}</td>
          <td>{expense.owner_id}</td>
          <td>{expense.sum_amount}</td>
        </tr>
      ))}
      </tbody>
    </table>
  )
}