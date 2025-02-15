if Rails.env.test?
  Rails.configuration.x.admin_secret = 'foobar'
else
  Rails.configuration.x.admin_secret = ENV.fetch('INCUNABULA_ADMIN_SECRET')
end
