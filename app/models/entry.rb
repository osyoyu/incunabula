class Entry < ApplicationRecord
  has_many :embed_links, dependent: :destroy
  has_one :import_source, dependent: :destroy

  scope :listable, -> { where(visibility: "public") }
  scope :diary, -> { where(title: nil) }
  scope :not_diary, -> { where.not(title: nil) }

  enum visibility: { public: "public", unlisted: "unlisted" }, _prefix: true  # no private state now

  def display_title
    title.nil? ? published_at_formatted : title
  end

  def published_at_formatted
    published_at.strftime('%Y/%-m/%-d')
  end

  def atom_feed_tag
    "tag:osyoyu.com,#{published_at.strftime("%Y-%m-%d")}:blog/#{Digest::MD5.hexdigest(id.to_s)[0,16]}"
  end

  def render_to_html
    rendered = Rendering::Renderer.render(body, self)
    CommonMarker.render_html(
      rendered,
      [:DEFAULT, :HARDBREAKS, :UNSAFE, :FOOTNOTES],
      [:table]
    ).html_safe
  end

  def prerender
    self.prerendered_body = Rendering::Prerenderer.render(self.body)
  end
end
