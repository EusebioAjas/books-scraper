# frozen_string_literal: true

require 'rubycritic_small_badge'
require 'rubycritic/rake_task'
require 'sandi_meter/file_scanner'

RubyCriticSmallBadge.configure do |config|
  config.minimum_score = ENV.fetch('RUBYCRITICLIMIT', 85.0)
  config.output_path = ENV.fetch('RUBYCRITPATH', 'badges/app')
end

RubyCritic::RakeTask.new do |task|
  task.options = %(--custom-format RubyCriticSmallBadge::Report
--minimum-score #{RubyCriticSmallBadge.config.minimum_score}
--format html --format console)
  task.paths = FileList['app/lib/*.rb']
end

task :test do
  system 'rspec app/spec/*.rb --format doc'
end

task :scraper do
  system 'ruby app/lib/scraper.rb'
end

task default: %w[test source test code]
