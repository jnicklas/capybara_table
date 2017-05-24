require "capybara_table/version"
require "capybara"
require "terminal-table"

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
      siblings = node.axis(:"preceding-sibling", :td, :th)
      without_colspan = siblings[XPath.attr(:colspan).inverse].count
      with_colspan = siblings.attr(:colspan).method(:sum)
      exists = node.method(:boolean).method(:number)

      without_colspan.plus(with_colspan).plus(exists)
    end
  end

  module Renderer
    extend self

    def render(node)
      node.synchronize do
        rows = node.all("tr").map do |row|
          row.all("th, td").map do |cell|
            {value: cell.text, colspan: (cell[:colspan] || 1).to_i}
          end
        end

        Terminal::Table.new(headings: rows.first, rows: rows.drop(1), style: {all_separators: true}).to_s
      end
    end
  end
end

Capybara.add_selector :table do
  xpath do |caption|
    XPath.descendant(:table)[XPath.descendant(:caption).string.n.is(caption)]
  end
end

Capybara.add_selector :table_row do
  xpath do |fields|
    fields.reduce(XPath.descendant(:tr)) do |xpath, (header, value)|
      xpath[CapybaraTable::Expressions.table_cell(header, value)]
    end
  end
end
