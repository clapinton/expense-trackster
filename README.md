# ExpenseTrackster

## Tech Stack and Architecture
**Backend**: Ruby on Rails and PostgreSQL

On the backend, a Rails MVC framework is configured to receive and respond to CRUD requests through API endpoints, making it agnostic to the frontend technology. The responses are formatted as JSON.

One static page is configured as html.erb, having the header and a single HTML element called `<div id="root">`. This will be the target that the frontend will look for.


**Frontend**: JS ES6 and React

A React component called `Root` gets rendered on the target HTML element `<div id="root">`. That component then renders other components (login or dashboard) according to the URL route.

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

### Users
Each user stores its email, password_digest and an is_admin flag. It also stores a random session_token, which is also stored in the browser's cookie on login. When the user logs out, the session_token is regenerated on the server, so it doesn't match the cookie's value anymore.

### Session
Session is only a controller which manages Log In and Log Out actions.

### Expenses
Besides all basic required fields, Expenses also store a `weeknum` in the integer form of `YYYYWW` (year digits followed by the week number digits). This is useful when generating a report, since we can easily group by the `weeknum` field when adding the expenses amounts. Also, since we have years before weeks, we can also use it to order when generating the report (notice that `WWYYYY` would not work for ordering purposes).

### Reports
The Reports features seem like a small one, so the initial thought was just building a simple SQL query under the Expenses model.

That option is not the best one since it's not scalable. If we want to expand the Reports and build more features into it (adding more filters, rendering more information etc), that would mean expanding the once simple reporting method inside Expenses. It wouldn't scale without going against the Single Responsibility Principle. Because of that, Reports was broken into its own model and controller.

Having a Reports model also gives us the option of trackability (we can see who generated each report, when and what set of filters was used). This is more important for auditing purposes, which is a more advanced feature for project at this point.

Date filters on the report are input as simple `YYYY-MM-DD`, while the Expense's `datetime` is `YYYY-MM-DD-T`, with time being in UTC. That means the filter's `to_date` will be non-inclusive, since `to_date` is seen as `00:00:00`. Therefore, we need to append `23:59:59` in order to make sure we include the `to_date` filter. That is done with the `#append_time_of_day` method inside the Report model. See below under **Improvements and Known bugs** for a different approach to this issue.

## Testing

### Backend

`bundle exec rspec` will run all specs.

`bundle exec rspec specs/user_spec.rb` will run the User model spec.

`bundle exec rspec specs/user_spec.rb:47` will only run the spec on line 47 of the User model.

Backend tests cover the following:

#### Models
|Model|Method|Test|
|--|--|--|
|User||Validates input param presence (`e-mail`, `password` and `is_admin` flag)|
|User||Accepts valid params|
|User||Validates `password` length|
|User||Does not save password to DB|
|User||Password is encrypted using BCrypt|
|User||Assigns a session_token|
|User||Finds user through credentials|
|User|find_by_credentials|Does not find user with incorrect password|
|User|find_by_credentials|Does not find user with incorrect email|
|Expense||Validates input param presence (`amount`, `datetime`, `description` and `owner_id`)|
|Expense||Validates `amount` digits|
|Expense||Accepts valid params|

#### Controllers
|Controller|Method|Test|
|--|--|--|
|Application||CSRF protection is set up|
|Users|show|Does not display user info when not logged in|
|Users|show|Displays user info to self|
|Users|show|Does not display another user's info, even if admin|
|Users|create|POST with valid parameters (user and admin)|
|Users|create|POST automatically logs in the user|
|Users|create|POST does not allow duplicate users|
|Users|create|POST fails with invalid parameters|
|Session|create|POST returns 404 with non-existing user|
|Session|create|POST returns 404 with incorrect password|
|Session|create|POST renders the user info with correct params|
|Session|create|POST logs in the user with correct params|
|Session|destroy|DELETE logs out the current user|
|Expenses|index|Does not display user info when not logged in|
|Expenses|index|Displays all expenses to admin|
|Expenses|index|Displays correct data to admin (`id`, `amount`, `datetime`, `description`, `owner_id`)|
|Expenses|index|Displays only self expenses to user|
|Expenses|index|Displays correct data to user (`id`, `amount`, `datetime`, `description`, `owner_id`)|
|Expenses|show|Does not display user info when not logged in|
|Expenses|show|Displays to admin an expense created by self|
|Expenses|show|Displays to admin an expense created by user|
|Expenses|show|Displays to user an expense created by self|
|Expenses|show|Does not display to user an expense created by another user|
|Expenses|create|Does not create new expenses when not logged in|
|Expenses|create|Creates new expenses with valid params, both as user and admin|
|Expenses|update|Does not update when not logged in|
|Expenses|update|Updates own expense with valid params as admin|
|Expenses|update|Does not update another user's expense as admin|
|Expenses|update|Does not update expense with invlid params as admin|
|Expenses|update|Updates own expense with valid params as user|
|Expenses|update|Does not update another user's expense as user|
|Expenses|update|Does not update expense with invlid params as user|
|Expenses|destroy|Does not delete expense when not logged in|
|Expenses|destroy|Deletes own expense as admin|
|Expenses|destroy|Does not Delete another user's expense as admin|
|Expenses|destroy|Deletes own expense as user|
|Expenses|destroy|Does not Delete another user's expense as user|

## Improvements and Known bugs

* When an expense is input, the timezone is not specified, and is then default to UTC. When a report gets generated, the date filters are manually default to UTC as well. One option would be to grab the timezone automatically from the client when the expense is created, but if the user is creating an expanse which happened in a different time zone (e.g. when the user was on a trip), then the system shouldn't use the clients time zone.
Another solution is giving the option to set the timezone whe creating the expense, but that will be an extra field which might not be necessary most of the time. Adding a `is_trip` flag that toggles the timezone selection is a possible solution.