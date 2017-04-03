import React from 'react';
import { deleteExpense } from '../../api/expenses_api';
// Material UI
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import getMuiTheme from 'material-ui/styles/getMuiTheme';
import darkBaseTheme from 'material-ui/styles/baseThemes/darkBaseTheme'
import { lightBlue600 } from 'material-ui/styles/colors';
import {Table, TableBody, TableHeader, TableHeaderColumn, TableRow, TableRowColumn} from 'material-ui/Table';
import FlatButton from 'material-ui/FlatButton'; 


const muiTheme = getMuiTheme({
    palette: {
        primary1Color: lightBlue600,
        primary2Color: lightBlue600,
        accent1Color: lightBlue600,
        accent2Color: lightBlue600,
        accent3Color: lightBlue600,
        alternateTextColor: lightBlue600
    },
});

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
        <FlatButton label={action} primary={true}
          onClick={this.handleClick(action, expense)}/>
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
      <div className="expenses-list">
        <MuiThemeProvider muiTheme={muiTheme}>
          <Table>
            <TableHeader displaySelectAll={false}>
              <TableRow>
                <TableHeaderColumn>Date</TableHeaderColumn>
                <TableHeaderColumn>Amount</TableHeaderColumn>
                <TableHeaderColumn>Description</TableHeaderColumn>
                <TableHeaderColumn>Owner</TableHeaderColumn>
                <TableHeaderColumn>Edit</TableHeaderColumn>
                <TableHeaderColumn>Delete</TableHeaderColumn>
              </TableRow>
            </TableHeader>
            <TableBody displayRowCheckbox={false} stripedRows={true}>
            {this.state.expenseList.map( expense => (
              <TableRow>
                <TableRowColumn>{expense.datetime}</TableRowColumn>
                <TableRowColumn>{expense.amount}</TableRowColumn>
                <TableRowColumn>{expense.description}</TableRowColumn>
                <TableRowColumn>{expense.owner_id}</TableRowColumn>
                <TableRowColumn>{this.renderButton(expense.owner_id, "edit", expense)}</TableRowColumn>
                <TableRowColumn>{this.renderButton(expense.owner_id, "delete", expense)}</TableRowColumn>
              </TableRow>
            ))}
            </TableBody>
          </Table>
        </MuiThemeProvider>  
      </div>      
    )
  }
}

export default ExpenseList;