# encoding: UTF-8

require 'rbconfig'

HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
gem 'mongoid'
gem 'mongoid-votable'
gem 'devise'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-weibo', git: 'git://github.com/jameszhan/omniauth-weibo.git'
gem 'cancan'

gem 'simple_form', "2.0.2"
gem 'redcarpet'
gem 'coderay'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 2.3.0.1'
  gem 'compass-rails'
  gem 'chosen-rails'
end

gem 'jquery-rails'

#emoji
gem 'md_emoji'

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
  gem 'pry-doc'
  gem 'sourcify'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem "mongoid-rspec"
  gem "email_spec"
  gem "launchy"
  gem "database_cleaner"  
  gem 'capybara', '1.1.2'
  
  gem 'shoulda-matchers', '~> 1.4.2'

  case HOST_OS
    when /linux/i
      #Linux relative gem
      gem 'rb-inotify'
      gem 'libnotify'
    when /darwin/i
      # Mac OS X relative gem
      gem 'rb-fsevent', :require => false
      gem 'growl', '1.0.3'
  end
end


