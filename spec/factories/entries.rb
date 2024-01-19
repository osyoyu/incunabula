FactoryBot.define do
  factory :entry do
    sequence(:title) { |n| "Entry #{n}" }
    sequence(:body) { "The quick brown fox jumps over the lazy dog" }
    published_at { Time.current }
  end
end
