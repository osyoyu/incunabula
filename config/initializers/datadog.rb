if ENV['DD_APM_ENABLED']
  Datadog.configure do |c|
    c.profiling.enabled = true
  end
end
