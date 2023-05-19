# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'bootsnap', require: false
gem 'city-state', git: 'https://github.com/thecodecrate/city-state'
gem 'cssbundling-rails', '~> 1.1'
gem 'devise', '~> 4.8.1'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'hotwire-rails'
gem 'httparty'
gem 'importmap-rails'
gem 'jbuilder'
gem 'jsbundling-rails', '~> 1.1'
gem 'pagy', '~> 6.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4', '>= 7.0.4.2'
gem 'responders', '~> 3.0.1'
gem 'sass-rails'
gem 'searchkick'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', '~> 1.5.0', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'elasticsearch-extensions'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end
