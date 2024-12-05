[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)

# Books Scraper

### Objective
Create a script that extracts book data from a website, including details such as title, image URL, rating, price, and stock availability, and stores this information in a database. The stored data can then be queried by the book's name to retrieve information efficiently.

### Installation
---------
Execute the following command to install gems.

```
bundle install
```
### Run tests
---------
```
rake test
```

### Run scripts
---------
Execute the scraper to extract and save data:
```
rake scraper
```

Finally, to execute search queries in the CLI:
```
rake searcher
```
