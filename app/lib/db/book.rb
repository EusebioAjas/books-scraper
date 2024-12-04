# frozen_string_literal: true

# Book Model
class Book
  attr_reader :title, :price, :image_url, :rating, :stock

  def initialize(attributes)
    @title = attributes[:title]
    @price = attributes[:price]
    @image_url = attributes[:image_url]
    @rating = attributes[:rating]
    @stock = attributes[:stock]
  end

  def to_h
    {
      title: title,
      price: price,
      image_url: image_url,
      rating: rating,
      stock: stock
    }
  end
end
