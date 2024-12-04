# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

##
# The `Item` struct is used to store and represent the scraped data for each book
# in a structured way, making it easy to access individual book attributes.
Item = Struct.new(:image_url, :rating, :title, :price, :stock)

##
# The class is responsible for scraping book data from the `https://books.toscrape.com` website.
# It retrieves information about books from each page, including the title, image URL, rating,
# price, and stock availability.
class Scraper
  BASE_URL = 'https://books.toscrape.com'
  RATING_MAP = {
    'One' => 1,
    'Two' => 2,
    'Three' => 3,
    'Four' => 4,
    'Five' => 5
  }.freeze

  attr_reader :books

  def initialize
    @books = []
  end

  def scrape_page(page_number)
    url = build_url(page_number)
    response = fetch_page(url)

    return nil unless response.success?

    html_books = parse_books(response.body)
    html_books.each do |html_book|
      @books << book_parser(html_book)
    end

    next_page_available?(response.body)
  end

  private

  def book_parser(html_book)
    image_url = extract_image_url(html_book)
    rating = extract_rating(html_book)
    title = extract_title(html_book)
    price = extract_price(html_book)
    stock = extract_stock(html_book)

    Item.new(image_url, rating, title, price, stock)
  end

  def build_url(page_number)
    "#{BASE_URL}/catalogue/page-#{page_number}.html"
  end

  def fetch_page(url)
    HTTParty.get(url)
  end

  def parse_books(html_content)
    document = Nokogiri::HTML(html_content)
    document.css('article.product_pod')
  end

  def next_page_available?(html_content)
    document = Nokogiri::HTML(html_content)
    !document.css('.next').empty?
  end

  def extract_image_url(html_book)
    img_src = html_book.css('img.thumbnail').first.attribute('src').value
    "#{BASE_URL}/#{img_src}"
  end

  def extract_rating(html_book)
    rating_element = html_book.at_css('.star-rating')
    return 0 unless rating_element

    rating_class = rating_element['class'].split[1]
    RATING_MAP[rating_class] || 0
  end

  def extract_title(html_book)
    html_book.css('h3>a').first.attribute('title').value
  end

  def extract_price(html_book)
    html_book.css('p.price_color').first.text.gsub('£', '').to_f
  end

  def extract_stock(html_book)
    stock_value = html_book.css('i.icon-ok').first
    stock_value ? 1 : 0
  end
end
