import React from 'react';

class ExpenseList extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <div className="expense-list">
        <table>
        <thead>
          <tr>
            <td>Date</td>
            <td>Amount</td>
            <td>Description</td>
            <td>Owner</td>
          </tr>
        </thead>
        <tbody>
        {this.props.expenseList.map( expense => (
          <tr>
            <td>{expense.datetime}</td>
            <td>{expense.amount}</td>
            <td>{expense.description}</td>
            <td>{expense.owner_id}</td>
          </tr>
        ))}
        </tbody>
        </table>
      </div>
    )
  }
}

export default ExpenseList;