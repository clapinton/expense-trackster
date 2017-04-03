# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.backtrace_exclusion_patterns = [/\.rvm/, /\.rbenv/]

  # So Rspec renders the view on the controller specs
  config.render_views
end

def sign_up_user
  user = User.create!(email: "user@domain.com",  password: "abcdef", is_admin: false)
end

def set_up_users_and_expenses
  let(:admin) { User.create!(email: "admin@domain.com",  password: "abcdef", is_admin: true) }
  let(:user) { User.create!(email: "user@domain.com",  password: "abcdef", is_admin: false) }
  let(:expense_admin) { Expense.create!(amount: 123.45, owner_id: admin.id, datetime: '2017-04-03T14:04:00.000Z', description: 'Created by an admin', weeknum: 201714) }
  let(:expense_user) { Expense.create!(amount: 678.90, owner_id: user.id, datetime: '2017-04-03T14:04:00.000Z', description: 'Created by a user', weeknum: 201714) }
end