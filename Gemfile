# encoding: UTF-8

require 'rbconfig'

HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
gem 'mongoid'
gem 'devise'
gem 'omniauth'
gem 'omniauth-github'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'


# To use debugger
# gem 'debugger'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec'

  #spork
  gem 'guard-spork'
  gem 'spork'
end

group :development do
  gem 'capistrano'
  gem 'pry'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem "mongoid-rspec"
  gem "email_spec"
  gem "launchy"
  gem "database_cleaner"  
  gem 'capybara', '1.1.2'
end

case HOST_OS
  when /linux/i
    #Linux 中需要的测试组 gem
    gem 'rb-inotify', :group=> :test
    gem 'libnotify', :group=> :test

  when /darwin/i
    # Mac OS X 中需要的测试组 gem
    gem 'rb-fsevent', '0.9.1', :require => false, :group=> :test
    gem 'growl', '1.0.3', :group=> :test
end
