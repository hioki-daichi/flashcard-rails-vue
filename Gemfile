source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.3"

gem "active_model_serializers"
gem "rails", "~> 5.2.0"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "uglifier", ">= 1.3.0"
gem "webpacker"
gem "turbolinks", "~> 5"
gem "bootsnap", ">= 1.1.0", require: false
gem "bcrypt"
gem "jwt"
gem "activerecord-import"
gem "rack-attack"
gem "config"
gem "ranked-model"
gem "graphql"

group :development, :test do
  gem "byebug"
  gem "rspec-rails"
  gem "dotenv-rails"
  gem "factory_bot"
  gem "faker"
  gem "rspec-json_matcher"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "index_shotgun"
end

group :test do
  gem "capybara", ">= 2.15", "< 4.0"
  gem "selenium-webdriver"
  gem "chromedriver-helper"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "codecov", require: false
end
