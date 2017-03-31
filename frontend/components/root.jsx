import React from 'react';
import { Router, Route, IndexRoute, hashHistory } from 'react-router';
import SessionForm from './session_form/session_form';

class Root extends React.Component {

  constructor(props) {
    super(props);
    this.store = this.props.store;
  }

  render() {
    return (
      <Router history={hashHistory}>
        <Route path="/login" component={SessionForm}/>
      </Router>
    )
  }

}

export default Root;