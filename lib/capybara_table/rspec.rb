require "capybara_table"

module CapybaraTable
  module RSpecMatchers
    def have_table(caption, **options)
      have_selector(:table, caption, **options)
    end

    def have_table_row(fields_and_options)
      fields, options = fields_and_options.partition { |k, v| k.is_a?(String) }

      have_selector(:table_row, fields.to_h, options.to_h)
    end
  end
end

RSpec.configure do |config|
  config.include CapybaraTable::RSpecMatchers, type: :feature
  config.include CapybaraTable::RSpecMatchers, type: :view
end
