require 'simplecov'
SimpleCov.start 'rails'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'factory_bot'
require 'ffaker'
require 'shoulda-matchers'
require 'rails-controller-testing'
require 'rspec-activemodel-mocks'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'

Dir[File.join(File.dirname(__FILE__), 'factories/**/*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :feature # once spree updates this can be removed

  config.color = true
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      # Choose a test framework:
      with.test_framework :rspec

      # Choose one or more libraries:er
      with.library :rails
    end
  end
end
