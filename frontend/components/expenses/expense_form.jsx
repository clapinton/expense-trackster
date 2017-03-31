import React from 'react';

class ExpenseForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      owner_id: window.currentUser.id,
      datetime: "",
      amount: 0.0,
      description: ""
    }

    this.handleUpdate = this.handleUpdate.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleUpdate(target) {
    return e => {
      this.setState({[target]: e.target.value});
    }
  }

  handleSubmit(e) {
    e.preventDefault();
    console.log(this.state);
  }


  render() {
    return(
      <div className="expense-form">
        <form>
          <label htmlFor="expenseAmount">Amount</label>
          <br/>
          <input type="number" name="expense[amount]" id="expenseAmount" onChange={this.handleUpdate("amount")}/>
          <br/>
          <br/>

          <label htmlFor="expenseDatetime">Date and Time</label>
          <br/>
          <input type="datetime-local" name="expense[datetime]" id="expenseDatetime" onChange={this.handleUpdate("datetime")}/>
          <br/>
          <br/>

          <label htmlFor="expenseDescription">Description</label>
          <br/>
          <input type="text" name="expense[description]" id="expenseDescription" onChange={this.handleUpdate("description")}/>
          <br/>
          <br/>

          <button onClick={this.handleSubmit}>Save</button>

        </form>
      </div>
    )
  }
}

export default ExpenseForm;