import React from 'react';
import { logout } from '../../api/session_api';
import { getAllExpenses } from '../../api/expenses_api';
import ExpenseForm from '../expenses/expense_form';
import ExpenseList from '../expenses/expense_list';

class Dashboard extends React.Component {
  constructor(props) {
    super(props);

    this.handleLogout = this.handleLogout.bind(this);
    this.logoutSuccess = this.logoutSuccess.bind(this);

    this.state = {
      expense: {},
      expenseList: []
    }

    this.saveSuccess = this.saveSuccess.bind(this);
    this.selectExpenseToEdit = this.selectExpenseToEdit.bind(this);
  }

  componentWillMount() {
    getAllExpenses( response => {
      this.setState({expenseList: response})
    });
  }  

  logoutSuccess(response) {
    window.currentUser = null;
    this.props.router.push("/login");
    console.log("Logout successful");
  }

  logoutError(error) {
    console.log("Logout error: ", error);
  }

  handleLogout(e) {
    e.preventDefault();
    logout(this.logoutSuccess, this.logoutError);
  }

  selectExpenseToEdit(expense) {
    this.setState({expense});
  }

  saveSuccess(response) {
    this.setState({expenseList: response, expense: {}});
    console.log("Expense save successful: ", this.state);
  }

  render() {
    return (
      <div className="dashboard">
        <h1>Dashboard</h1>
        <ExpenseForm expense={this.state.expense} saveSuccess={this.saveSuccess}/>
        <ExpenseList expenseList={this.state.expenseList} selectExpenseToEdit={this.selectExpenseToEdit}/>
      <button onClick={this.handleLogout}>Logout</button>
      </div>
    )
  }
}

export default Dashboard;