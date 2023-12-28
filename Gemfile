source "https://rubygems.org"

gem "rails", "~> 7.1.2"

gem "commonmarker", "~> 0.23"
gem "haml"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "ridgepole"
gem "tzinfo-data"

group :production do
  gem "ddtrace", require: 'ddtrace/auto_instrument'
end

group :development, :test do
  gem "debug"
  gem "rspec-rails"
  gem "rspec-daemon"
end

group :development do
  gem "rubocop"
end
