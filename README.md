# ExpenseTrackster

## Tech Stack and Architecture
**Backend**: Ruby on Rails and PostgreSQL

On the backend, a Rails MVC framework is configured to receive and respond to CRUD requests through API endpoints, making it agnostic to the frontend technology. The responses are formatted as JSON.

One static page is configured as html.erb, having the header and a single HTML element called `<div id="root">`. This will be the target that the frontend will look for.


**Frontend**: JS ES6 and React

A React component called `Root` gets rendered on the target `<div id="root">`. That component then renders other components (login or dashboard) according to the URL route.

## Backend Structure

### Auth
Authentication was written using the following framework:
* backend receives username (email) and password as plain text;
* the password is validated (min. 6 chars) and then hashed using the BCrypt gem, generating a password_digest;
* a model of a User with the username and password_digest is created;
* if it's a valid user (non-existent and with valid credentials), it gets created and commited to the DB. If not, an error is raised;
* on login, the input password is compared against the password_digest using the `BCrypt#is_password?(password)` method;
* if login is successful, a session_token is generated and saved to the respective User and stored in the client's cookie: `session[:session_token] = user.session_token`;
* the pure text password is, therefore, never stored anywhere and is discarded as soon as the login process finalizes with either success or error.

## Testing

### Backend

`bundle exec rspec` will run all specs.
`bundle exec rspec specs/user_spec.rb` will run the User model spec.
`bundle exec rspec specs/user_spec.rb:47` will only run the spec on line 47 of the User model.