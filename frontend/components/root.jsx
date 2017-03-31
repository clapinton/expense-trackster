import React from 'react';
import { Router, Route, IndexRoute, hashHistory } from 'react-router';
import SessionForm from './session_form/session_form';
import Dashboard from './dashboard/dashboard';

class Root extends React.Component {

  constructor(props) {
    super(props);
    this.store = this.props.store;
  }

  redirectIfLoggedOut(nextState, replace) {
    if (!window.currentUser) {
      replace('/login');
    }
  }

  render() {
    return (
      <Router history={hashHistory}>
        <Route path="/login" component={SessionForm}/>
        <Route path="/signup" component={SessionForm}/>
        <Route path="/dashboard" component={Dashboard} onEnter={this.redirectIfLoggedOut}/>
      </Router>
    )
  }

}

export default Root;