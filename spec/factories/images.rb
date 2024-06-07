FactoryBot.define do
  factory :image do
    original_filename { 'IMG_1234.jpg' }
    content_type { 'image/jpeg' }
    s3_key { '20240606100000_3e2c80620c79.jpg' }
  end
end
