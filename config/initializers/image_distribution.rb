Rails.configuration.x.image_distribution = {
  s3_bucket: ENV.fetch('INCN_IMAGE_DISTRIBUTION_S3_BUCKET'),
  s3_prefix: ENV.fetch('INCN_IMAGE_DISTRIBUTION_S3_PREFIX'),
}
