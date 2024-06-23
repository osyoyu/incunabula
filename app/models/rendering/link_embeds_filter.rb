module Rendering
  class LinkEmbedsFilter
    def call(text, context_entry)
      text.gsub(LinkEmbed::TARGET_TEXT_REGEX) do |match|
        url = $1

        if url.match?(EmbedLink::TWITTER_URL_REGEX)
          # Twitter embed
          embed_link = context_entry.embed_links.detect { |link| link.url == url }
          if embed_link
            embed_link.html
          else
            match
          end
        else
          # Generic link embed
          embed_link = context_entry.link_embeds.detect { |link| link.url == url }
          if embed_link
            embed_link.as_html
          else
            match
          end
        end
      end
    end
  end
end
