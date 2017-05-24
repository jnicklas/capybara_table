require "capybara_table/version"
require "capybara"

module CapybaraTable
end

Capybara.add_selector :table_row do
  xpath do |fields|
    fields.reduce(XPath.descendant(:tr)) do |xpath, (header, value)|
      header_node = XPath.axis(:ancestor, :table)[1].descendant(:tr)[1].descendant(:th)[XPath.string.n.is(header)]

      header_without_colspan = header_node.axis(:"preceding-sibling")[XPath.attr(:colspan).inverse].count
      header_with_colspan = header_node.axis(:"preceding-sibling").attr(:colspan).method(:sum)
      header_exists = header_node.method(:boolean).method(:number)

      header_position = header_without_colspan.plus(header_with_colspan).plus(header_exists)

      cell_node = XPath.axis(:self)

      cell_without_colspan = cell_node.axis(:"preceding-sibling")[XPath.attr(:colspan).inverse].count
      cell_with_colspan = cell_node.axis(:"preceding-sibling").attr(:colspan).method(:sum)
      cell_exists = cell_node.method(:boolean).method(:number)

      cell_position = cell_without_colspan.plus(cell_with_colspan).plus(cell_exists)

      xpath[XPath.descendant(:td, :th)[XPath.string.n.is(value).and(header_position.equals(cell_position))]]
    end
  end
end
