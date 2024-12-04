# frozen_string_literal: true

require_relative 'scraper'
require_relative 'db/db_manager'

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

db_manager = DBManager.new('db/books.db')
db_manager.setup

books = scraper.books
db_manager.books.insert(books)
