require "capybara_table/version"
require "capybara"

module CapybaraTable
  module Expressions
    extend self

    def table_cell(header, value)
      XPath.descendant(:td, :th)[XPath.string.n.is(value).and(header_position(header).equals(self_position))]
    end

    def self_position
      cell_position(XPath.axis(:self))
    end

    def header_position(header)
      header_node = XPath.axis(:ancestor, :table)[1].descendant(:tr)[1].descendant(:th)[XPath.string.n.is(header)]
      cell_position(header_node)
    end

    def cell_position(node)
      without_colspan = node.axis(:"preceding-sibling")[XPath.attr(:colspan).inverse].count
      with_colspan = node.axis(:"preceding-sibling").attr(:colspan).method(:sum)
      exists = node.method(:boolean).method(:number)

      without_colspan.plus(with_colspan).plus(exists)
    end
  end
end

Capybara.add_selector :table_row do
  xpath do |fields|
    fields.reduce(XPath.descendant(:tr)) do |xpath, (header, value)|
      xpath[CapybaraTable::Expressions.table_cell(header, value)]
    end
  end
end
