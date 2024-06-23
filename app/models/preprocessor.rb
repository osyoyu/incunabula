class Preprocessor
  def self.process!(...)
    new.process!(...)
  end

  def process!(entry)
    markdown = entry.body
    Preprocessor::TwitterUrlFilter.new.call(markdown, entry)
  end
end
