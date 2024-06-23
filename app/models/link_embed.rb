class LinkEmbed < ApplicationRecord
  validates :url, presence: true
end
