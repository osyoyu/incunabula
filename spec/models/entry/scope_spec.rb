require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe '.listable' do
    it 'excludes unlisted' do
      entry1 = create(:entry, entry_path: '123', visibility: "public")
      entry2 = create(:entry, entry_path: '123', visibility: "unlisted")
      expect(Entry.listable.count).to eq(1)
      expect(Entry.listable.first.id).to eq(entry1.id)
    end
  end
end
