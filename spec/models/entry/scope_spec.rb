require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe '.public' do
    it 'excludes drafts' do
      entry1 = create(:entry, entry_path: '123', is_draft: false)
      entry2 = create(:entry, entry_path: '123', is_draft: true)
      expect(Entry.published.count).to eq(1)
      expect(Entry.published.first.id).to eq(entry1.id)
    end
  end
end
