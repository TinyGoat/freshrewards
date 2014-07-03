source 'https://rubygems.org'

#Use latest version of rails 4
gem 'rails',                  '~> 4.1.1'

# Use postgresql as the database for Active Record
gem 'pg',                     '~> 0.17.1'

# Use SCSS for stylesheets
gem 'sass-rails',             '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier',               '~> 2.5.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails',           '~> 4.0.1'

# jQuery for easy interaction with the DOM
gem 'jquery-rails',           '~> 3.1.0'

# Turbolinks makes following links in your web application faster
gem 'turbolinks',             '~> 2.2.2'

# jBuilder for constructing JSON responses
gem 'jbuilder',               '~> 1.2'

# Pony for delivering email
gem 'pony',                   '~> 1.8'

# Devise for user registration/authentication
gem 'devise',                 '~> 3.2.4'

#FriendlyID for easy to use slugs for our URLs
gem 'friendly_id',            '~> 5.0.0'

#Carrierwave for file attachment management
gem 'carrierwave',            '~> 0.10.0'

#WillPaginate for handling pagination of collections
gem 'will_paginate',          '~> 3.0.5'

# Using Puma as the app server
gem 'puma',                   '~> 2.8.2'

# Compass is a simple, powerful SCSS framework
gem 'compass-rails',          '~> 1.1.7'

# ZURB foundation for easy styling of the application
gem 'foundation-rails',       '~> 5.2.2'

# Addressable is an easy way to encode URLs
gem 'addressable',            '~> 2.3.6'

# Net::SFTP is a pure Ruby implementation of SFTP
gem 'net-sftp',               '~> 2.1.2'

# Paranoia for deactivating customers without removing them from the database
gem 'paranoia',               '~> 2.0.2'

group :development do
  #Don't show me the log message from the asset pipeline in development
  gem 'quiet_assets',               '~> 1.0.2'

  #Spring to load our environments faster
  gem 'spring',                     '~> 1.1.3'
  gem 'spring-commands-rspec',      '~> 1.0.2'
  gem 'spring-commands-teaspoon',   '~> 0.0.2'
end

group :production do
  #Make sure that the application can run on a 12 factor platform
  gem 'rails_12factor',       '~> 0.0.2'

  #Always output the application log to STDOUT
  gem 'rails_log_stdout',                     github: 'heroku/rails_log_stdout'
end

group :development, :test do
  #rb-readline
  gem 'rb-readline',          '~> 0.5.1'

  # Pry is a nice drop in for irb, which allows for debugging
  # of your code anywhere 'binding.pry' is included
  gem 'pry',                  '~> 0.9.12'

  #Pry remote allows debugging of code not running in main thread of execution
  gem 'pry-remote',           '~> 0.1.8'

  #Pry rails replaces the rails console IRB prompt with Pry
  gem 'pry-rails',            '~> 0.3.2'

  #Pry nav allows for compiled langugage debugger like functionality inside Pry
  gem 'pry-nav',              '~> 0.2.3'

  #Awesome print for sweet output in the pry console
  gem 'awesome_print',        '~> 1.1.0'

  # Guard for file monitoring
  gem 'guard',                '~> 2.6.1'

  #Guard bundler to ensure our bundle is always up to date
  gem 'guard-bundler',        '~> 2.0.0'

  #Guard livereload to automatically reload the current html view when changes are made
  gem 'guard-livereload',     '~> 2.2.0'

  #Guard ctags bundler will generate ctags for all the bundled gems automatically when the bundle
  #changes
  gem 'guard-ctags-bundler',  '~> 1.0.2'

  #Guard puma to restart puma each any time any of the major application files change
  gem 'guard-puma',           '~> 0.2.4'
end

group :test do
  #DatabaseCleaner to make sure the database is ready in between tests
  gem 'database_cleaner',     '~> 1.3.0'

  #Rspec for testing instead of test::unit
  gem 'rspec-rails',          '~> 2.14.2'

  #Capybara for acceptance testing
  gem 'capybara',             '~> 2.2.1'

  #Poltergeist is a PhantomJS driver for Capybara to run features that are JS intensitve
  gem 'poltergeist',          '~> 1.5.0'

  #Launchy for opening up pages for inspection during automated testing
  gem 'launchy',              '~> 2.3.0'

  #Timecop for easy manipulation of Time when testing
  gem 'timecop',              '~> 0.7.1'
end
