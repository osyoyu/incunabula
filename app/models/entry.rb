class Entry < ApplicationRecord
  scope :diary, -> { where(title: nil) }
  scope :not_diary, -> { where.not(title: nil) }

  def display_title
    title.nil? ? published_at_formatted : title
  end

  def published_at_formatted
    published_at.strftime('%Y/%m/%d')
  end
end
