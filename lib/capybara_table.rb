require "capybara_table/version"
require "capybara"

module CapybaraTable
  extend self

  def cell_position(node)
    without_colspan = node.axis(:"preceding-sibling")[XPath.attr(:colspan).inverse].count
    with_colspan = node.axis(:"preceding-sibling").attr(:colspan).method(:sum)
    exists = node.method(:boolean).method(:number)

    without_colspan.plus(with_colspan).plus(exists)
  end
end

Capybara.add_selector :table_row do
  xpath do |fields|
    fields.reduce(XPath.descendant(:tr)) do |xpath, (header, value)|
      header_node = XPath.axis(:ancestor, :table)[1].descendant(:tr)[1].descendant(:th)[XPath.string.n.is(header)]
      header_position = CapybaraTable.cell_position(header_node)

      cell_node = XPath.axis(:self)
      cell_position = CapybaraTable.cell_position(cell_node)

      xpath[XPath.descendant(:td, :th)[XPath.string.n.is(value).and(header_position.equals(cell_position))]]
    end
  end
end
