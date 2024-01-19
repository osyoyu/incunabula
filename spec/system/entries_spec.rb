require 'rails_helper'

RSpec.describe 'Entries', type: :system do
  before do
    driven_by :rack_test
  end

  describe '/blog' do
    context 'happy path' do
      it 'responds with 200' do
        visit '/blog'
        expect(page).to have_http_status(200)
      end
    end
  end

  describe '/blog/:entry_path' do
    let!(:entry) { create(:entry, entry_path: '2024/01/19/000000') }
    context 'happy path' do
      it 'responds with 200' do
        visit '/blog/2024/01/19/000000'
        expect(page).to have_http_status(200)
      end
    end
  end
end
