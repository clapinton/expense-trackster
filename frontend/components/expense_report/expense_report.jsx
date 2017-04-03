import React from 'react';
import ExpenseReportList from './expense_report_list';

class ExpenseReport extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      fromDate: "",
      toDate: "",
      reportedExpenses: []
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
    reportRange = {from_date: this.state.fromDate, to_date: this.state.toDate};
    createReport(reportRange, this.props.saveSuccess, this.saveError);
  }


  render() {
    return(
      <div className="expense-report">
        <form>
          <label htmlFor="fromDate">From:</label>
          <br/>
          <input type="datetime-local" name="report[from_date]" id="fromDate"
            onChange={this.handleUpdate("fromDate")} value={this.state.fromDate}/>
          <br/>

          <label htmlFor="fromDate">To:</label>
          <br/>        
          <input type="datetime-local" name="report[to_date]" id="toDate"
            onChange={this.handleUpdate("toDate")} value={this.state.toDate}/>
          <br/>

          <button onClick={this.handleSubmit}>Generate Report</button>
        </form>

        <ExpenseReportList reportedExpenses={this.state.reportedExpenses}/>

      </div>
    )
  }

}

export default ExpenseReport;