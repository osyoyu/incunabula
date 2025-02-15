if Rails.env.test?
  Rails.configuration.x.image_distribution = {
    s3_bucket: 'osyoyu-static',
    s3_prefix: 'incunabula-test',
    public_url_host: 'static.example.com',
  }
else
  Rails.configuration.x.image_distribution = {
    s3_bucket: ENV.fetch('INCN_IMAGE_DISTRIBUTION_S3_BUCKET'),
    s3_prefix: ENV.fetch('INCN_IMAGE_DISTRIBUTION_S3_PREFIX'),
    public_url_host: ENV.fetch('INCN_IMAGE_DISTRIBUTION_PUBLIC_URL_HOST'),
  }
end
