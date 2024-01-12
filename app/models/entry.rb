class Entry < ApplicationRecord
  scope :diary, -> { where(title: nil) }
  scope :not_diary, -> { where.not(title: nil) }

  def display_title
    title.nil? ? published_at_formatted : title
  end

  def published_at_formatted
    published_at.strftime('%Y/%m/%d')
  end

  def atom_feed_tag
    "tag:osyoyu.com,#{published_at.strftime("%Y-%m-%d")}:blog/#{Digest::MD5.hexdigest(id.to_s)[0,16]}"
  end

  def render_to_html
    CommonMarker.render_html(self.body, [:DEFAULT, :HARDBREAKS, :UNSAFE, :FOOTNOTES], [:table]).html_safe
  end
end
