class FeedController < ApplicationController
  def show
    channel_name = params[:id]
    entries =
      case channel_name
      when "all"
        Entry.all.order(published_at: :desc).limit(10)
      when "general"
        Entry.not_diary.order(published_at: :desc).limit(10)
      else
        render plain: "not found", status: :not_found
        return
      end

    feed = RSS::Maker.make('atom') do |maker|
      maker.channel.title = "osyoyu.com/blog (#{channel_name.capitalize})"
      maker.channel.link = 'https://osyoyu.com/blog'
      maker.channel.author = 'osyoyu'
      maker.channel.about = 'https://osyoyu.com/blog'
      maker.channel.updated = entries.first.published_at.iso8601

      entries.each do |entry|
        maker.items.new_item do |item|
          item.link = entry_friendly_url(entry_path: entry.entry_path)
          item.title = entry.display_title
          item.date = entry.published_at.iso8601
        end
      end
    end

    render xml: feed.to_xml
  end
end
