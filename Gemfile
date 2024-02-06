source "https://rubygems.org"

gem "rails", "~> 7.1.2"

gem "commonmarker", "~> 0.23"
gem "haml"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "ridgepole"
gem "rss"
gem "sprockets-rails"
gem "tzinfo-data"

group :production do
  gem "ddtrace", require: 'ddtrace/auto_instrument'
end

group :development, :test do
  gem "debug"

  gem "capybara"
  gem "factory_bot_rails"
  gem "rspec-daemon"
  gem "rspec-rails"
  gem "ruby-lsp-rspec", require: false
end

group :development do
  gem "rubocop"
end
