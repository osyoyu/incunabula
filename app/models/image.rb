class Image < ApplicationRecord
  S3_BUCKET = Rails.configuration.x.image_distribution[:s3_bucket]
  S3_PREFIX = Rails.configuration.x.image_distribution[:s3_prefix]

  validates :original_filename, presence: true
  validates :content_type, presence: true
  validates :s3_key, presence: true

  # @param file [ActionDispatch::Http::UploadedFile]
  def self.from_uploaded_file(file)
    new(
      original_filename: file.original_filename,
      content_type: file.content_type,
    )
  end

  def self.strip_exif!(path)
    system('exiftool', '-overwrite_original_in_place', '-gps*=', path, exception: true)
  end

  def public_url(resize_options = nil)
    if resize_options
      options_str = resize_options.map { |k, v| "#{k}=#{v}" }.join(',')
      "https://#{Rails.configuration.x.image_distribution[:public_url_host]}/cdn-cgi/image/#{options_str}/#{self.s3_key}"
    else
      "https://#{Rails.configuration.x.image_distribution[:public_url_host]}/#{self.s3_key}"
    end
  end

  # Assign a new S3 key and upload the blob.
  # @param blob [String]
  def upload_to_s3(blob)
    filename = self.generate_filename
    self.s3_key = "#{S3_PREFIX}/img/original/#{filename}"

    s3 = Aws::S3::Client.new
    s3.put_object(
      bucket: S3_BUCKET,
      key: self.s3_key,
      body: blob,
      content_type: self.content_type,
    )
  end

  def generate_filename
    timestamp = Time.current.strftime('%Y%m%d%H%M%S')
    random = SecureRandom.hex(6)
    extension = File.extname(original_filename)

    "#{timestamp}_#{random}#{extension}"
  end
end
