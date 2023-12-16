class Entry < ApplicationRecord
  def published_at_formatted
    published_at.strftime('%Y/%m/%d')
  end
end
