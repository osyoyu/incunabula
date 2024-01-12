class FeedController < ApplicationController
  def index
    entries = Entry.all.order(published_at: :desc).limit(10)
    feed = RSS::Maker.make('atom') do |maker|
      maker.channel.id = "tag:osyoyu.com,2023:blog"
      maker.channel.title = "osyoyu.com/blog"
      maker.channel.link = 'https://osyoyu.com/blog'
      maker.channel.author = 'osyoyu'
      maker.channel.about = 'https://osyoyu.com/blog'
      maker.channel.updated = entries.first.published_at.iso8601

      entries.each do |entry|
        maker.items.new_item do |item|
          item.id = entry.atom_feed_tag
          item.link = entry_friendly_url(entry_path: entry.entry_path)
          item.title = entry.display_title
          item.date = entry.published_at.iso8601
        end
      end
    end
    render xml: feed.to_xml
  end
end
