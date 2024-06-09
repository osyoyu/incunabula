module Rendering
  # A renderer to "prerender" some tags known to be time-consuming.
  #
  # There is no real need to split prerendering and online rendering,
  # as all content is static and could be rendered into HTML files on submission.
  # However, to capture a fruitful Ruby CPU profile, we aim to burn as much CPU as possible
  # (as long as it's meaningful) inside entry#show.
  class Prerenderer
    def self.render(...)
      new.render(...)
    end

    def render(markdown)
      Rendering::TwitterUrlFilter.new.call(markdown)
    end
  end
end
