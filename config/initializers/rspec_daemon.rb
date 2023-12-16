if Rails.env.test? && ENV['RSPEC_DAEMON']
  Rails.configuration.enable_reloading = true
end
