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

      klass = begin
        Capybara::RSpecMatchers::Matchers::HaveSelector
      rescue NameError
        Capybara::RSpecMatchers::HaveSelector
      end
      selector = klass.new(:table_row, fields, options)

      match do |node|
        selector.matches?(node)
      end

      match_when_negated do |node|
        selector.does_not_match?(node)
      end

      failure_message do |node|
        node = node.document if node.is_a?(Capybara::Session)
        node.synchronize do
          tables = node.all(:xpath, XPath.descendant_or_self(:table)).map do |table|
            CapybaraTable::Renderer.render(table)
          end

          selector.failure_message + " in the following tables:\n\n" + tables.join("\n\n")
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include CapybaraTable::RSpecMatchers, type: :feature
  config.include CapybaraTable::RSpecMatchers, type: :system
  config.include CapybaraTable::RSpecMatchers, type: :view
end
