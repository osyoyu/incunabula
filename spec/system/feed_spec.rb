require 'rails_helper'

RSpec.describe 'Feed', type: :system do
  before do
    driven_by :rack_test
  end

  describe '/blog/feed' do
    context 'happy path' do
      let!(:entry) { create(:entry, entry_path: '2024/01/19/000000') }
      it 'responds with 200' do
        visit '/blog/feed'
        expect(page).to have_http_status(200)
        expect(page.response_headers['Content-Type']).to eq('application/xml; charset=utf-8')
      end
    end
  end
end
