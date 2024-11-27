# frozen_string_literal: true

require 'simplecov'

SimpleCov.start
SimpleCov.minimum_coverage 60

RSpec.configure do |config|
  config.warnings = true
end
