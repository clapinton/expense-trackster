import React from 'react';
import { getExpense, createExpense, editExpense } from '../../api/expenses_api';

class ExpenseForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      id: "",
      datetime: "",
      amount: "",
      description: "",
      owner_id: "",
      isEdit: false
    }

    this.handleUpdate = this.handleUpdate.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.getSuccess = this.getSuccess.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    if (Object.keys(nextProps.expense).length === 0) {
      this.setState({id: "", amount: "", datetime: "", description: "", owner_id: "", isEdit: false});
    } else {
      getExpense(nextProps.expense, this.getSuccess, this.getError);
    }
  }

  getSuccess({id, datetime, amount, description, owner_id}) {
    this.setState({id, datetime, amount, description, owner_id, isEdit: true});
  }

  getError(error) {
    console.log("There was an error when fetching the expense: ", error);
  }

  handleUpdate(target) {
    return e => {
      this.setState({[target]: e.target.value});
    }
  }

  saveError(error) {
    console.log("Error while saving expense: ", error);
  }

  handleSubmit(e) {
    e.preventDefault();
    const expense = this.state;
    if (this.state.isEdit) {
      editExpense(expense, this.props.saveSuccess, this.saveError);
    } else {
      createExpense(expense, this.props.saveSuccess, this.saveError);
    }
  }


  render() {
    return(
      <div className="expense-form">
        <form>
          <label htmlFor="expenseAmount">Amount</label>
          <br/>
          <input type="text" name="expense[amount]" id="expenseAmount" 
            onChange={this.handleUpdate("amount")} value={this.state.amount}/>
          <br/>
          <br/>

          <label htmlFor="expenseDatetime">Date and Time</label>
          <br/>
          <input type="datetime-local" name="expense[datetime]" id="expenseDatetime"
            onChange={this.handleUpdate("datetime")} value={this.state.datetime}/>
          <br/>
          <br/>

          <label htmlFor="expenseDescription">Description</label>
          <br/>
          <input type="text" name="expense[description]" id="expenseDescription"
            onChange={this.handleUpdate("description")} value={this.state.description}/>
          <br/>
          <br/>

          <button onClick={this.handleSubmit}>Save</button>

        </form>
      </div>
    )
  }
}

export default ExpenseForm;