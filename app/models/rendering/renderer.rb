module Rendering
  class Renderer
    def self.render(...)
      new.render(...)
    end

    def render(markdown, context_entry)
      Rendering::EmbedLinksFilter.new.call(markdown, context_entry)
    end
  end
end
