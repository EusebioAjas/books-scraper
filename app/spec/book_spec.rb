# frozen_string_literal: true

require 'rspec'
require_relative '../lib/db/book'

describe Book do
  let(:book_attributes) do
    {
      title: 'Dracula the Un-Dead',
      price: 35.63,
      image_url: 'https://books.toscrape.com/media/23232.jpg',
      rating: 5,
      stock: 1
    }
  end

  subject(:book) { Book.new(book_attributes) }

  describe '#initialize' do
    it 'sets the title' do
      expect(book.title).to eq('Dracula the Un-Dead')
    end

    it 'sets the price' do
      expect(book.price).to eq(35.63)
    end

    it 'sets the image_url' do
      expect(book.image_url).to eq('https://books.toscrape.com/media/23232.jpg')
    end

    it 'sets the rating' do
      expect(book.rating).to eq(5)
    end

    it 'sets the stock' do
      expect(book.stock).to eq(1)
    end
  end

  describe '#to_h' do
    it 'returns a hash with the correct attributes' do
      expect(book.to_h).to eq(book_attributes)
    end
  end
end
