# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

Book = Struct.new(:image_url, :rating, :title, :price, :stock)

# Sample Scraper class
class Scraper
  BASE_URL = 'https://books.toscrape.com'

  attr_accessor :books

  def initialize
    @books = []
  end

  private

  def book_parser(html_book)
    img_src = html_book.css('img.thumbnail').first.attribute('src').value
    image = "#{BASE_URL}/#{img_src}"

    rating_element = html_book.at_css('.star-rating')
    rating = rating_element['class'].split[1] if rating_element

    title = html_book.css('h3>a').first.attribute('title').value
    price = html_book.css('p.price_color').first.text
    stock = html_book.css('i.icon-ok').first.attribute('class').value

    Book.new(image, rating, title, price, stock)
  end

  public

  def scrape_page(page_number)
    url = "#{BASE_URL}/catalogue/page-#{page_number}.html"
    response = HTTParty.get(url)
    document = Nokogiri::HTML(response.body)

    return nil unless response.success?

    selector = 'article.product_pod'

    html_books = document.css(selector)
    html_books.each do |html_book|
      @books << book_parser(html_book)
    end
    next_page_link = document.css('.next')

    next_page_link ? true : false
  end

  def greetings
    'hello'
  end
end

scraper = Scraper.new

spinner = ['|', '/', '-', '\\']
i = 0
page_number = 1

while true
  next_page = scraper.scrape_page(page_number)
  print "\rLoading #{spinner[i]}"
  i = (i + 1) % spinner.length
  break unless next_page

  page_number += 1
end

print "\rDone!         \n"

print scraper.books
print scraper.books.size
