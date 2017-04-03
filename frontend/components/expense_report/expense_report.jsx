import React from 'react';
import ExpenseReportList from './expense_report_list';
import { createReport } from '../../api/expenses_api';

class ExpenseReport extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      filters: {
        from_date: "",
        to_date: ""
      },
      reportedExpenses: []
    }

    this.handleUpdate = this.handleUpdate.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.reportSuccess = this.reportSuccess.bind(this);
  }

  handleUpdate(target) {
    return e => {
      let newFilters = this.state.filters;
      newFilters[target] = e.target.value
      this.setState({filters: newFilters});
      console.log(this.state)
    }
  }

  handleSubmit(e) {
    e.preventDefault();
    // console.log("sending with ", this.state.filters);
    createReport(this.state.filters, this.reportSuccess, this.reportError);
  }

  reportSuccess(response) {
    this.setState({reportedExpenses: response})
  }

  reportError(error) {
    console.log("Error while saving expense: ", error);
  }

  render() {
    return(
      <div className="expense-report">
        <form>
          <label htmlFor="fromDate">From:</label>
          <br/>
          <input type="date" name="report[from_date]" id="fromDate"
            onChange={this.handleUpdate("from_date")} value={this.state.fromDate}/>
          <br/>

          <label htmlFor="fromDate">To:</label>
          <br/>        
          <input type="date" name="report[to_date]" id="toDate"
            onChange={this.handleUpdate("to_date")} value={this.state.toDate}/>
          <br/>

          <button onClick={this.handleSubmit}>Generate Report</button>
        </form>

        <ExpenseReportList reportedExpenses={this.state.reportedExpenses}/>

      </div>
    )
  }

}

export default ExpenseReport;