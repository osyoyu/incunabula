class Preprocessor
  class UrlFilter
    def call(text, context_entry)
      text.scan(LinkEmbed::TARGET_TEXT_REGEX).each do |matches|
        url = matches[0]
        if url.match?(EmbedLink::TWITTER_URL_REGEX)
          # Twitter embed
          create_twitter_embed!(url, context_entry)
        else
          # Generic link embed
          link_embed = context_entry.link_embeds.find_or_initialize_by(url:)
          link_embed.fetch_attributes_and_save!
        end
      end
    end

    private def create_twitter_embed!(url, context_entry)
      conn = Faraday.new(url: 'https://publish.twitter.com')
      conn.options.timeout = 3 # seconds
      res = conn.get('/oembed', { url: })
      if res.success?
        body = JSON.parse(res.body, symbolize_names: true)
        html = body[:html]
        if context_entry.embed_links.find_by(url:) == nil
          context_entry.embed_links.create!(url:, html:)
        end
      end
    end
  end
end
