# TODO: Rename to TwitterEmbed
class EmbedLink < ApplicationRecord
  TWITTER_URL_REGEX = %r{\Ahttps://(?:twitter|x)\.com/[0-9a-zA-Z_]+/status/\d+/?\z}
end
