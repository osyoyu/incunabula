module Rendering
  class EmbedLinksFilter
    REGEX = %r{\[(https?://.+?):embed\]}

    def call(text, context_entry)
      text.gsub(REGEX) do |match|
        url = $1

        embed_link = context_entry.embed_links.detect { |link| link.url == url }
        if embed_link
          embed_link.html
        else
          match
        end
      end
    end
  end
end
