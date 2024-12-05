# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'
require_relative '../lib/scraper'

RSpec.describe Scraper do
  let(:scraper) { Scraper.new }

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe '#scrape_page' do
    context 'when the page is successfully fetched' do
      before do
        stub_request(:get, 'https://books.toscrape.com/catalogue/page-1.html')
          .to_return(body: inline_page_1_html, status: 200)
      end

      it 'parses the books on the page' do
        scraper.scrape_page(1)
        expect(scraper.books.length).to eq(2)
      end
    end

    context 'when the page is not found or has no books' do
      before do
        stub_request(:get, 'https://books.toscrape.com/catalogue/page-999.html')
          .to_return(status: 404)
      end

      it 'returns nil for unsuccessful requests' do
        expect(scraper.scrape_page(999)).to be_nil
      end
    end
  end

  describe '#next_page_available?' do
    context 'when there is a next page' do
      before do
        stub_request(:get, 'https://books.toscrape.com/catalogue/page-1.html')
          .to_return(body: inline_page_1_html, status: 200)
      end

      it 'returns true' do
        scraper.scrape_page(1)
        expect(scraper.send(:next_page_available?, inline_page_1_html)).to be true
      end
    end

    context 'when there is no next page' do
      before do
        stub_request(:get, 'https://books.toscrape.com/catalogue/page-2.html')
          .to_return(body: inline_page_2_no_next_html, status: 200)
      end

      it 'returns false' do
        scraper.scrape_page(2)
        expect(scraper.send(:next_page_available?, inline_page_2_no_next_html)).to be false
      end
    end
  end

  describe '#book_parser' do
    let(:html_book) { Nokogiri::HTML(inline_single_book_html).css('article.product_pod').first }

    it 'parses the book attributes correctly' do
      item = scraper.send(:book_parser, html_book)
      expect(item.title).to eq('A Light in the Attic')
      expect(item.price).to eq(51.77)
      expect(item.stock).to eq(1)
      expect(item.rating).to eq(5)
      expect(item.image_url).to eq('https://books.toscrape.com/media/cache/97/ee/97ee1778b9374f72a05bb957eafc8850.jpg')
    end
  end

  describe '#extract_rating' do
    let(:html_book) { Nokogiri::HTML(inline_single_book_html).css('article.product_pod').first }

    it 'extracts the correct rating' do
      rating = scraper.send(:extract_rating, html_book)
      expect(rating).to eq(5)
    end

    it 'returns 0 when rating is not present' do
      html_book_without_rating = Nokogiri::HTML('<article class="product_pod"></article>').css('article.product_pod').first
      rating = scraper.send(:extract_rating, html_book_without_rating)
      expect(rating).to eq(0)
    end
  end

  # Inline HTML content as strings
  def inline_page_1_html
    <<-HTML
      <html>
        <body>
          <article class="product_pod">
            <h3><a title="A Light in the Attic" href="a-light-in-the-attic_1000/index.html">A Light in the Attic</a></h3>
            <p class="price_color">£51.77</p>
            <p class="instock availability"><i class="icon-ok"></i> In Stock</p>
            <img class="thumbnail" src="media/cache/97/ee/97ee1778b9374f72a05bb957eafc8850.jpg" alt="A Light in the Attic">
            <p class="star-rating Five"></p>
          </article>
          <article class="product_pod">
            <h3><a title="Tipping the Velvet" href="tipping-the-velvet_999/index.html">Tipping the Velvet</a></h3>
            <p class="price_color">£53.74</p>
            <p class="instock availability"><i class="icon-ok"></i> In Stock</p>
            <img class="thumbnail" src="media/cache/97/ee/97ee1778b9374f72a05bb957eafc8850.jpg" alt="Tipping the Velvet">
            <p class="star-rating Four"></p>
          </article>
          <ul class="pager">
            <li class="next"><a href="page-2.html">next</a></li>
          </ul>
        </body>
      </html>
    HTML
  end

  def inline_page_2_no_next_html
    <<-HTML
      <html>
        <body>
          <article class="product_pod">
            <h3><a title="A Light in the Attic" href="a-light-in-the-attic_1000/index.html">A Light in the Attic</a></h3>
            <p class="price_color">£51.77</p>
            <p class="instock availability"><i class="icon-ok"></i> In Stock</p>
            <img class="thumbnail" src="media/cache/97/ee/97ee1778b9374f72a05bb957eafc8850.jpg" alt="A Light in the Attic">
            <p class="star-rating Five"></p>
          </article>
        </body>
      </html>
    HTML
  end

  def inline_single_book_html
    <<-HTML
      <html>
        <body>
          <article class="product_pod">
            <h3><a title="A Light in the Attic" href="a-light-in-the-attic_1000/index.html">A Light in the Attic</a></h3>
            <p class="price_color">£51.77</p>
            <p class="instock availability"><i class="icon-ok"></i> In Stock</p>
            <img class="thumbnail" src="media/cache/97/ee/97ee1778b9374f72a05bb957eafc8850.jpg" alt="A Light in the Attic">
            <p class="star-rating Five"></p>
          </article>
        </body>
      </html>
    HTML
  end
end
