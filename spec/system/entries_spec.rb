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

  describe 'Entry creation' do
    context 'When the entry has only plain text' do
      it do
        expect(Entry.count).to eq(0)

        visit '/blog/entries/new'

        fill_in 'entry[title]', with: 'Nice title'
        fill_in 'entry[body]', with: 'Nice content'
        fill_in 'incunabula_admin_secret', with: ENV['INCUNABULA_ADMIN_SECRET']
        click_on 'Create Entry'

        expect(Entry.count).to eq(1)

        expect(page).to have_text('Nice title')
        expect(page).to have_text('Nice content')
      end
    end

    context 'When the entry has Twitter embeds' do
      before do
        stub_request(:get, "https://publish.twitter.com/oembed?url=https://twitter.com/osyoyu/status/1234567890")
          .to_return(
            status: 200,
            body: { html: '<blockquote>Twitter embed</blockquote>' }.to_json
          )
      end

      it do
        expect(Entry.count).to eq(0)
        expect(EmbedLink.count).to eq(0)

        visit '/blog/entries/new'

        fill_in 'entry[title]', with: 'Nice title'
        fill_in 'entry[body]', with: <<~__EOS__
          Nice content
          [https://twitter.com/osyoyu/status/1234567890:embed]
        __EOS__
        fill_in 'incunabula_admin_secret', with: ENV['INCUNABULA_ADMIN_SECRET']
        click_on 'Create Entry'

        expect(Entry.count).to eq(1)
        expect(EmbedLink.count).to eq(1)
        embed_link = EmbedLink.last
        expect(embed_link.url).to eq('https://twitter.com/osyoyu/status/1234567890')
        expect(embed_link.html).to eq('<blockquote>Twitter embed</blockquote>')

        expect(page).to have_text('Nice title')
        expect(page).to have_text('Nice content')
      end
    end
  end
end
