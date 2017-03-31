import React from 'react';
import { deleteExpense } from '../../api/expenses_api';

class ExpenseList extends React.Component {
  constructor(props) {
    super(props);

    this.state={
      expenseList:[]
    }

    this.operationSuccess = this.operationSuccess.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({expenseList: nextProps.expenseList});
  }

  renderButton(ownerId, action, expense) {
    if (window.currentUser.id === ownerId) {
      return(
        <button onClick={this.handleClick(action, expense)}>{action}</button>
      )
    }
  }

  operationSuccess(response) {
    console.log("Operation successful");
    this.setState({expenseList: response})
  }

  operationError(error) {
    console.log("An error occurred", error);
  }

  handleClick(action, expense) {
    return ( e => {
      e.preventDefault();
      switch (action) {
        case "edit":
          this.props.selectExpenseToEdit(expense);
          break;
        case "delete":
          deleteExpense(expense, this.operationSuccess, this.operationError);
          break;
      }
    })
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
            <td>Edit</td>
            <td>Delete</td>
          </tr>
        </thead>
        <tbody>
        {this.state.expenseList.map( expense => (
          <tr>
            <td>{expense.datetime}</td>
            <td>{expense.amount}</td>
            <td>{expense.description}</td>
            <td>{expense.owner_id}</td>
            <td>{this.renderButton(expense.owner_id, "edit", expense)}</td>
            <td>{this.renderButton(expense.owner_id, "delete", expense)}</td>
          </tr>
        ))}
        </tbody>
        </table>
      </div>
    )
  }
}

export default ExpenseList;