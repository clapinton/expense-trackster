import React from 'react';
import { withRouter } from 'react-router';
import { Link } from 'react-router';
import { signup, login } from '../../api/session_api';

class SessionForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      email: "",
      password: "",
      is_admin: false
    };

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleUpdate(property) {
    return e => this.setState({[property]: e.target.value})
  }

  loginSuccess(response) {
    console.log(response);
  }

  loginError(response) {
    console.log(response);
  }

  handleSubmit(e) {
    e.preventDefault();
    const user = this.state;
    if (this.isLoginForm()) {
      login({user}, this.loginSuccess, this.loginError);
    } else {
      signup({user}, this.loginSuccess, this.loginError);
    }
  }  

  isLoginForm() {
    return this.props.location.pathname === "/login"
  }

  renderButtons() {
    if (this.isLoginForm()) {
      return (<button className="user-login-btn"
            onClick={this.handleSubmit}>Login</button>
      );
    } else {
      return (<button className="user-login-btn"
        onClick={this.handleSubmit}>Signup</button>);
    }
  }

  alternativeEntrance() {
    if (this.isLoginForm()) {
      return <Link to="/signup" onClick={this.switchForms}>Sign up instead</Link>;
    } else {
      return <Link to="/login" onClick={this.switchForms}>Log in instead</Link>;
    }
  } 

  render() {
    const formTitle = this.isLoginForm() ? "Login" : "Signup";
    const alternativeEntrance = (this.isLoginForm()) ? "signup" : "login";

    return (
      <div className = "session-form">

        <div className="session-form-wrapper">

          <h1>{formTitle}</h1>

          <form>

            <label htmlFor="email">Email</label>
            <br/>
            <input type="text" name="user[email]" id="email" onChange={this.handleUpdate("email")}/>
            <br/>
            <br/>

            <label htmlFor="password">Password</label>
            <br/>
            <input type="password" name="user[password]" id="password" onChange={this.handleUpdate("password")}/>
            <br/>
            <br/>

            {this.renderButtons()}
            <br/>
          </form>
          {this.alternativeEntrance()}
        </div>
      </div>
    )
  }
}

// Export withRouter to have access to this.props.route.{passedInProps}
export default withRouter(SessionForm);