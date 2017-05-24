require "capybara_table"
require "capybara/rspec"

module CapybaraTable
  module RSpecMatchers
    extend RSpec::Matchers::DSL
    def have_table(caption, **options)
      have_selector(:table, caption, **options)
    end

    matcher :have_table_row do |fields_and_options|
      fields, options = fields_and_options.partition { |k, v| k.is_a?(String) }.map(&:to_h)
      selector = Capybara::RSpecMatchers::HaveSelector.new(:table_row, fields, options)

      match do |node|
        selector.matches?(node)
      end

      match_when_negated do |node|
        selector.does_not_match?(node)
      end

      failure_message do |node|
        node.synchronize do
          table = node.first(:xpath, XPath.axis(:"ancestor-or-self", :table))

          if table
            selector.failure_message + " in the following table:\n\n" + CapybaraTable::Renderer.render(table)
          else
            selector.failure_message
          end
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include CapybaraTable::RSpecMatchers, type: :feature
  config.include CapybaraTable::RSpecMatchers, type: :view
end
