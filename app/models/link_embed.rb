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

  def as_html
    uri = URI.parse(self.url)

    <<-__EOS__
<div class="embedded-link-card">
  <div class="embedded-link-card-content">
    <div class="embedded-link-card-title">
      <strong><a href="#{self.url}" target="_blank">#{self.title}</a></strong>
    </div>
    <div class="embedded-link-card-description">#{self.description&.truncate(80)}</div>
    <div class="embedded-link-card-host">#{uri.host}</div>
  </div>
#{if self.image_url
    "<div class=\"embedded-link-card-image\">
  <a href=\"#{self.url}\" target=\"_blank\">
    <img src=\"#{self.image_url}\" />
  </a>
</div>"
else
  ""
end}
</div>
__EOS__
  end
end
