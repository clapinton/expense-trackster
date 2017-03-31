import React from 'react';
import { logout } from '../../api/session_api';

class Dashboard extends React.Component {
  constructor(props) {
    super(props);

    this.handleLogout = this.handleLogout.bind(this);
    this.logoutSuccess = this.logoutSuccess.bind(this);
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

  render() {
    return (
      <div className="dashboard">
        Dashboard
      <button onClick={this.handleLogout}>Logout</button>
      </div>
    )
  }
}

export default Dashboard;