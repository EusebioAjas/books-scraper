# frozen_string_literal: true

##
# This class represents a book object.
#
# The `Book` class stores information about a book, including its title,
# price, image_url, rating a stock available.
#
# Attributes:
# - title [String] The title of the book.
# - price [Float] The price of the book.
# - image_url [String] The rating of the book (from 1 to 5).
# - stock [Integer] The stock availability (1 - true, 0 - false)
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
