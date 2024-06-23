class Preprocessor
  def self.process!(...)
    new.process!(...)
  end

  def process!(entry)
    Preprocessor::UrlFilter.new.call(entry.body, entry)
    true
  end
end
