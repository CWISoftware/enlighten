source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.5.1'
gem 'rails-i18n'

# slim templates
gem 'slim-rails'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'compass-rails', '2.0.5'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'

# Forms
gem 'simple_form'
gem 'cocoon'

# Active record audits
gem 'paper_trail', '~> 4.0.0.rc'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Authentication
gem 'devise'
gem 'devise-i18n'
gem 'devise_ldap_authenticatable'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# github flavored markdown
gem 'redcarpet'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# usefull
gem 'awesome_print'
gem 'irbtools', require: 'irbtools/binding'

# Heroku gem
gem 'rails_12factor', group: :production

# Send files
gem 'refile', require: ['refile/rails']
gem 'refile-mini_magick'
gem 'refile-s3'

# Code quality
gem 'rubocop', require: false
gem 'slim_lint', require: false
gem 'scss_lint', require: false

# Application monitoring
gem 'newrelic_rpm'

# Application Permission
gem 'pundit'

# Manage Environment Variables
gem 'figaro'

# jQuery Plugin to Build Pinterest Grid
gem 'jquery-masonry-rails'

# Pagination
gem 'kaminari'
gem 'api-pagination'

# Serializer
gem 'active_model_serializers'

# Gravatar
gem 'gravatar-ultimate'

# Bower
gem 'bower-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Annottate models with the current schema calling "annotate" on the cli
  gem 'annotate', '~> 2.6.6'

  # Logs all not found i18n tags
  gem 'i18n-debug'

  # Command line debugging, just add "binding.pry" anywhere on the code
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-stack_explorer'

  # for rails panel
  gem 'meta_request'

  # silence assets from rails logs
  gem 'quiet_assets'

  # unit testing
  gem 'rspec-rails', '~> 3.0'

  # bdd
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'selenium-webdriver'

  # Generates test data
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'

  # Test matchers
  gem 'shoulda-matchers'
  gem 'rspec-collection_matchers'

  # Calculates code coverage
  gem 'simplecov', require: false

  # Reports coverage to clode climate
  gem 'codeclimate-test-reporter', require: nil

  # Security vulnerability tests
  gem 'brakeman', require: false
end

group :development, :production do
  # background-jobs
  gem 'sidekiq', '4.0.0'
end

ruby '2.2.2'
gem 'rails-html-sanitizer', '~> 1.0.3'
