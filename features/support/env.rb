require 'cucumber/rails'

require 'capybara/cucumber'
require 'rspec/rails'
require 'capybara/poltergeist'
require 'paper_trail/frameworks/cucumber'

module Cucumber
  module Rails
    class World
      include FactoryGirl::Syntax::Methods
    end
  end
end

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

Capybara.register_driver :poltergeist do |app|
  options = {
    js_errors: false,
    timeout: 120,
    debug: false,
    phantomjs_options: ['--load-images=no', '--disk-cache=false'],
    inspector: true,
    window_size: [1024, 2048]
  }

  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.default_driver = :poltergeist

# Screenshots after steps - good for debugging
screenshots_folder = Rails.root.join('screenshots')
screenshots_folder.children.each(&:unlink) if screenshots_folder.exist?

screenshot_count = 0

AfterStep do |scenario|
  page.save_screenshot screenshots_folder.join("scr-#{screenshot_count}-#{scenario.title.parameterize}.png")
  screenshot_count += 1
end
