require "capybara_table/version"
require "capybara"

module CapybaraTable
end

Capybara.add_selector :table_row do
  xpath do |fields|
    fields.reduce(XPath.descendant(:tr)) do |xpath, (header, value)|
      header_node = XPath.axis(:ancestor, :table)[1].descendant(:tr)[1].descendant(:th)[XPath.string.n.is(header)]
      header_position = header_node.axis(:"preceding-sibling").count.plus(header_node.method(:boolean).method(:number)).equals(XPath.position)
      xpath[XPath.descendant(:td, :th)[XPath.string.n.is(value).and(header_position)]]
    end
  end
end
