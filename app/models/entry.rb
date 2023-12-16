class Entry < ApplicationRecord
  def display_title
    title.nil? ? published_at_formatted : title
  end

  def published_at_formatted
    published_at.strftime('%Y/%m/%d')
  end
end
