require 'rails_helper'

RSpec.describe Image, type: :model do
  describe '#public_url' do
    context 'when resize_options is specified' do
      it do
        image = Image.new(
          original_filename: 'IMG_1234.jpg',
          content_type: 'image/jpeg',
          s3_key: '20240606095000_25e616570eb9.jpg'
        )

        expect(image.public_url({ width: 480 })).to eq('https://static.example.com/cdn-cgi/image/width=480/20240606095000_25e616570eb9.jpg')
      end
    end

    context 'when resize_options is not specified' do
      it do
        image = Image.new(
          original_filename: 'IMG_1234.jpg',
          content_type: 'image/jpeg',
          s3_key: '20240606095000_25e616570eb9.jpg'
        )

        expect(image.public_url).to eq('https://static.example.com/20240606095000_25e616570eb9.jpg')
      end
    end
  end
end
