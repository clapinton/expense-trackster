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
      expenseId: "",
      expenseList: []
    }

    this.saveSuccess = this.saveSuccess.bind(this);
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

  saveSuccess(response) {
    this.setState({expenseList: response, expenseId: ""});
    console.log("Expense save successful: ", this.state);
  }

  render() {
    return (
      <div className="dashboard">
        <h1>Dashboard</h1>
        <ExpenseForm expenseId={this.state.expenseId} saveSuccess={this.saveSuccess}/>
        <ExpenseList expenseList={this.state.expenseList}/>
      <button onClick={this.handleLogout}>Logout</button>
      </div>
    )
  }
}

export default Dashboard;