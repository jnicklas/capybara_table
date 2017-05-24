require "capybara_table"

module CapybaraTable
  module RSpecMatchers

  end
end

RSpec.configure do |config|
  config.include CapybaraTable::RSpecMatchers, type: :feature
  config.include CapybaraTable::RSpecMatchers, type: :view
end
