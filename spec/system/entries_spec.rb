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

    context 'when unlisted entries exist' do
      let!(:published) {
        create(:entry, title: 'Published', entry_path: '2024/06/15/020000', visibility: "public")
      }
      let!(:unlisted) {
        create(:entry, title: 'Very draft', entry_path: '2024/06/15/030000', visibility: "unlisted")
      }

      it 'does not show them' do
        visit '/blog'
        expect(page).to have_http_status(200)
        expect(page).to have_content('Published')
        expect(page).to_not have_content('Very draft')
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

    context 'even if entry is unlisted' do
      let!(:unlisted) {
        create(:entry, title: 'Very draft', entry_path: '2024/06/15/030000', visibility: "unlisted")
      }

      it 'shows it' do
        visit '/blog/2024/06/15/030000'
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
        fill_in 'incunabula_admin_secret', with: Rails.configuration.x.admin_secret
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
        fill_in 'incunabula_admin_secret', with: Rails.configuration.x.admin_secret
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

    context 'When the entry has generic URL embeds' do
      before do
        stub_request(:get, "https://osyoyu.com/")
          .to_return(
            status: 200,
            body: "<html><head><meta property='og:title' content='osyoyu.com title'></head></html>"
          )
      end

      it 'renders a link card' do
        expect(Entry.count).to eq(0)
        expect(LinkEmbed.count).to eq(0)

        visit '/blog/entries/new'

        fill_in 'entry[title]', with: 'Nice title'
        fill_in 'entry[body]', with: <<~__EOS__
          Nice content
          [https://osyoyu.com/:embed]
        __EOS__
        fill_in 'incunabula_admin_secret', with: Rails.configuration.x.admin_secret
        click_on 'Create Entry'

        expect(Entry.count).to eq(1)
        expect(LinkEmbed.count).to eq(1)
        link_embed = LinkEmbed.last
        expect(link_embed.url).to eq('https://osyoyu.com/')
        expect(link_embed.title).to eq('osyoyu.com title')

        expect(page).to have_text('Nice title')
        expect(page).to have_text('osyoyu.com title')
        expect(page).to have_text('Nice content')
      end
    end
  end
end
