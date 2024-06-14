module Prerendering
  class TwitterUrlFilter
    REGEX = %r{\[(https://(?:twitter|x)\.com/[0-9a-zA-Z_]+/status/\d+/?):embed\]}

    def call(text, context_entry)
      conn = Faraday.new(url: 'https://publish.twitter.com')
      conn.options.timeout = 3 # seconds

      text.gsub(REGEX) do |match|
        url = $1

        res = conn.get('/oembed', { url: })
        if res.success?
          body = JSON.parse(res.body, symbolize_names: true)
          html = body[:html]

          if context_entry.embed_links.find_by(url:) == nil
            context_entry.embed_links.create!(url:, html:)
          end
        else
          match
        end
      end
    end
  end
end
