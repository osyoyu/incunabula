require 'rails_helper'

RSpec.describe 'Images', type: :system do
  before do
    driven_by :rack_test
  end

  describe '/blog/images/new' do
    context 'happy path' do
      it 'responds with 200' do
        visit '/blog/images/new'
        expect(page).to have_http_status(200)
      end
    end
  end

  describe '/blog/images/:id' do
    context 'happy path' do
      let!(:image) { create(:image) }

      it 'responds with 200' do
        visit "/blog/images/#{image.id}"
        expect(page).to have_http_status(200)
      end
    end
  end
end
