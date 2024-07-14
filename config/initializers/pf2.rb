require 'pf2/reporter'

if ENV['PF2_CONTINUOUS_PROFILING'].to_i == 1
  s3 = Aws::S3::Client.new
  local_path = Rails.root.join('tmp/pf2prof/latest.pf2prof')

  Thread.new {
    loop do
      profiler = Pf2::Session.new(
        scheduler: :signal,
        threads: :all,
        time_mode: :wall,
        interval_ms: 9,
      )
      profiler.start

      sleep ENV.fetch('PF2_CONTINUOUS_PROFILING_SLEEP_SECS', "5").to_i

      profile = profiler.stop

      # Generate Firefox Profiler format in an external process to avoid SystemStackError
      # (the current pf2prof format nests too deep; restructuring in progress)
      File.write(local_path, profile)
      stdout, stderr, status = Open3.capture3("bundle exec pf2 report #{local_path}")
      if status.exitstatus != 0
        Sentry.capture_message('pf2 report failed')
      end
      report = stdout

      s3.put_object(
        bucket: 'osyoyu-pf2prof',
        key: 'incunabula-latest.firefoxprofiler.json',
        body: report,
        content_type: 'application/json'
      )
      s3.put_object(
        bucket: 'osyoyu-pf2prof',
        key: "incunabula-#{Time.now.to_i}.firefoxprofiler.json",
        body: report,
        content_type: 'application/json'
      )
      Rails.logger.debug("Pf2: Written to S3")
    end
  }
end
