require "capybara_table/version"
require "capybara"
require "terminal-table"
require "xpath"

module CapybaraTable
  module XPath
    include ::XPath
    extend self

    def table(caption)
      descendant(:table)[descendant(:caption).string.n.is(caption)]
    end

    def table_row(fields)
      fields.reduce(descendant(:tr)) do |xpath, (header, value)|
        xpath[table_cell(header, value)]
      end
    end

    def table_cell(header, value)
      descendant(:td, :th)[string.n.is(value).and(header_position(header).equals(self_position))]
    end

    def self_position
      cell_position(self_axis)
    end

    def header_position(header)
      header_node = ancestor(:table)[1].descendant(:thead, :tr)[1].descendant(:th)[string.n.is(header)]
      cell_position(header_node)
    end

    def cell_position(node)
      siblings = node.preceding_sibling(:td, :th)

      without_colspan = siblings[attr(:colspan).inverse].count
      with_colspan = siblings.attr(:colspan).sum
      exists = node.boolean.number

      without_colspan.plus(with_colspan).plus(exists)
    end
  end

  module Renderer
    extend self

    def render(node)
      node.synchronize do
        rows = node.all("thead, tr").map do |row|
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
    CapybaraTable::XPath.table(caption)
  end
end

Capybara.add_selector :table_row do
  xpath do |fields|
    CapybaraTable::XPath.table_row(fields)
  end
end
