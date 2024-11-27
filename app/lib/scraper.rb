# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

Book = Struct.new(:image, :rating, :title, :price, :in_stock)

# Sample Scraper class
class Scraper
  BASE_URL = 'https://books.toscrape.com'
  def books
    response = HTTParty.get(BASE_URL)
    document = Nokogiri::HTML(response.body)
    selector = 'article.product_pod'
    html_books = document.css(selector)
    books_arr = []
    html_books.each do |html_book|
      img_src = html_book.css('img.thumbnail').first.attribute('src').value
      image = "#{BASE_URL}/#{img_src}"
      rating = []
      html_book.css('.star-rating').each do |element|
        class_name = element['class'].split
        second_class_name = class_name[1]

        rating << second_class_name if second_class_name
      end
      title = html_book.css('h3>a').first.attribute('title').value
      price = html_book.css('p.price_color').first.text
      in_stock = html_book.css('i.icon-ok').first.attribute('class')

      book = Book.new(image, rating, title, price, in_stock)
      books_arr << book
    end

    puts books_arr
  end

  def greetings
    'hello'
  end
end

scraper = Scraper.new
scraper.books
