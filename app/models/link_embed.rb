class LinkEmbed < ApplicationRecord
  TARGET_TEXT_REGEX = %r{^\[(https?://.*):embed\]\r?$}

  validates :url, presence: true

  def fetch_attributes_and_save!
    raise "No URL specified" if self.url == nil

    res = Faraday.get(url, nil, {
      'User-Agent' => 'Mozilla/5.0 (compatible; osyoyu.com)',
      'Accept-Language' => 'ja,en-US,en',
    })
    parsed = Nokogiri::HTML(res.body)

    # Title
    self.title = parsed.css('meta[property="og:title"]').first&.[]('content') || parsed.css('title').first.text

    # Description
    self.description =
      parsed.css('meta[property="og:description"]').first&.[]('content') ||
      parsed.css('meta[name="description"]').first&.[]('content')

    # Image URL
    self.image_url = parsed.css('meta[property="og:image"]').first&.[]('content')

    # Site name
    self.site_name = parsed.css('meta[property="og:site_name"]').first&.[]('content')

    self.save!
  end
end
