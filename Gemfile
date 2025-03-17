source "https://rubygems.org"

gem "rails", "~> 8.0.2"

gem "aws-sdk-s3"
gem "commonmarker", "~> 0.23"
gem "faraday"
gem "haml"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "ridgepole"
gem "rss"
gem "sentry-ruby"
gem "sprockets-rails"
gem "tzinfo-data"

# Temporary for Ruby 3.5 (3.4?) compat
gem "benchmark"
gem "fiddle"
gem "mutex_m"
gem "ostruct"

group :development, :test do
  gem "debug"
  gem "dotenv"

  gem "capybara"
  gem "factory_bot_rails"
  gem "rspec-daemon"
  gem "rspec-rails"
  gem "ruby-lsp-rspec", require: false
end

group :development do
  gem "rubocop"
end

group :test do
  gem "webmock"
end
