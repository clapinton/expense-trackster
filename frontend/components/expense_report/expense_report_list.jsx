import React from 'react';

export default function ExpenseReportList({reportedExpenses}) {
  return (
    <table className="expense-report-list">
        <thead>
          <tr>
            <td>Week</td>
            <td>Expenses Total</td>
          </tr>
        </thead>
        <tbody>
      {reportedExpenses.map( expense => (
        <tr>
          <td>{expense.weeknum}</td>
          <td>{expense.sum_amount}</td>
        </tr>
      ))}
      </tbody>
    </table>
  )
}