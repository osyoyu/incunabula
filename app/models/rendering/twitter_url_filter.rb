module Rendering
  class TwitterUrlFilter
    REGEX = %r{\[(https://(?:twitter|x)\.com/[0-9a-zA-Z_]+/status/\d+/?):embed\]}

    def initialize
      @conn = Faraday.new(url: 'https://publish.twitter.com')
      @conn.options.timeout = 3 # seconds
    end

    def call(text)
      text.gsub(REGEX) do |match|
        res = @conn.get('/oembed', { url: $1 })
        if res.success?
          body = JSON.parse(res.body, symbolize_names: true)
          body[:html]
        else
          match
        end
      end
    end
  end
end
