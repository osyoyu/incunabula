require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe '#display_title' do
    context 'when title is nil' do
      let(:entry) { build(:entry, title: nil, published_at: Time.parse('2024-01-20T01:20:00+09:00')) }
      it 'returns published_at_formatted' do
        expect(entry.display_title).to eq('2024/1/20')
      end
    end

    context 'when title is not nil' do
      let(:entry) { build(:entry, title: 'title') }
      it 'returns title' do
        expect(entry.display_title).to eq('title')
      end
    end
  end

  describe '#published_at_formatted' do
    context 'when month/day is single-digit' do
      let(:entry) { build(:entry, published_at: Time.parse('2024-01-20T01:20:00+09:00')) }
      it 'returns formatted published_at' do
        expect(entry.published_at_formatted).to eq('2024/1/20')
      end
    end

    context 'when month/day is double-digit' do
      let(:entry) { build(:entry, published_at: Time.parse('2024-10-20T01:20:00+09:00')) }
      it 'returns formatted published_at' do
        expect(entry.published_at_formatted).to eq('2024/10/20')
      end
    end
  end
end
