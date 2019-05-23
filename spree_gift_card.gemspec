Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_gift_card'
  s.version     = '3.7.0'
  s.summary     = 'Spree Gift Card'
  s.description = 'Spree Gift Card Extension'

  s.authors     = ['Jeff Dutil']
  s.email       = ['jdutil@burlingtonwebapps.com']
  s.homepage    = 'https://github.com/vinsol/spree_gift_card'


  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_path = 'lib'
  s.required_ruby_version = '>= 2.2.7'
  s.requirements << 'none'

  s.add_dependency 'spree_api',         '>= 3.2.0' , '< 4.0'
  s.add_dependency 'spree_backend',     '>= 3.2.0' , '< 4.0'
  s.add_dependency 'spree_core',        '>= 3.2.0' , '< 4.0'
  s.add_dependency 'spree_frontend',    '>= 3.2.0' , '< 4.0'
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'capybara', '~> 2.6'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.4'
  s.add_development_dependency 'sass-rails', '~> 5.0.4'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1.1'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'rails-controller-testing', '~> 1.0.1'
  s.add_development_dependency 'poltergeist'
end
