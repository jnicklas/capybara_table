require "spec_helper"

require "capybara_table"
require "capybara_table/rspec"

describe CapybaraTable, type: :feature do
  let(:simple_table) { Capybara.string(fixture("simple_table.html")) }
  let(:table_with_colspan) { Capybara.string(fixture("table_with_colspan.html")) }
  let(:nested_table) { Capybara.string(fixture("nested_table.html")) }

  describe :table do
    it "finds a table by caption" do
      expect(table_with_colspan).to have_table("People")
      expect(table_with_colspan).not_to have_table("People", exact: true)
      expect(table_with_colspan).not_to have_table("WRONG")
    end
  end

  describe :table_row do
    it "matches a single field" do
      expect(simple_table).to have_table_row("First Name" => "Jonas")
      expect(simple_table).not_to have_table_row("First Name" => "WRONG")
    end

    it "does not match incorrect keys" do
      expect(simple_table).not_to have_table_row("Last Name" => "Jonas")
      expect(simple_table).not_to have_table_row("WRONG" => "Jonas")
    end

    it "matches multiple fields" do
      expect(simple_table).to have_table_row("First Name" => "Jonas", "Last Name" => "Nicklas")
      expect(simple_table).to have_table_row("First Name" => "Jonas", "Age" => 31)

      expect(simple_table).not_to have_table_row("First Name" => "Jonas", "Last Name" => "Smith")
      expect(simple_table).not_to have_table_row("First Name" => "Jonas", "Last Name" => "WRONG")
    end

    it "supports nested tables" do
      expect(nested_table).to have_table_row("First Name" => "Jonas", "Age" => "31")
      expect(nested_table).not_to have_table_row("Thing" => "Jonas", exact: true)
      expect(nested_table).not_to have_table_row("Quox" => "Nicklas")
    end

    it "supports colspans" do
      expect(table_with_colspan).to have_table_row("First Name" => "Jonas", "Age" => "31")
      expect(table_with_colspan).not_to have_table_row("First Name" => "Jonas", "Age" => "44")
      expect(table_with_colspan).not_to have_table_row("First Name" => "Jonas", "Last Name" => "31")

      expect(table_with_colspan).to have_table_row("First Name" => "John", "Last Name" => "Smith", "Age" => "22")
      expect(table_with_colspan).not_to have_table_row("Age" => "Esq")
      expect(table_with_colspan).not_to have_table_row("Last Name" => "Esq")

      expect(table_with_colspan).to have_table_row("First Name" => "Harry", "Age" => "56")
    end

    it "prints a nice failure message" do
      node = simple_table.find("table")
      matcher = have_table_row("First Name" => "Moo", count: 2)
      matcher.matches?(node)

      expect(matcher.failure_message).to eq <<~MESSAGE.chomp
        expected to find visible table_row {"First Name"=>"Moo"} within #<Capybara::Node::Simple tag="table" path="/html/body/table"> 2 times but there were no matches in the following tables:

        +------------+-----------+-----+
        | First Name | Last Name | Age |
        +------------+-----------+-----+
        | Jonas      | Nicklas   | 31  |
        +------------+-----------+-----+
        | John       | Smith     | 22  |
        +------------+-----------+-----+
      MESSAGE
    end
  end

  describe "Renderer" do
    it "renders a simple table" do
      table = simple_table.find("table")
      result = CapybaraTable::Renderer.render(table)
      expect(result).to eq <<~TABLE.chomp
        +------------+-----------+-----+
        | First Name | Last Name | Age |
        +------------+-----------+-----+
        | Jonas      | Nicklas   | 31  |
        +------------+-----------+-----+
        | John       | Smith     | 22  |
        +------------+-----------+-----+
      TABLE
    end

    it "renders a table with colspans" do
      table = table_with_colspan.find("table")
      result = CapybaraTable::Renderer.render(table)
      expect(result).to eq <<~TABLE.chomp
        +------------+-------+-----+-----+
        | First Name | Last Name   | Age |
        +------------+-------+-----+-----+
        | Jonas                    | 31  |
        +------------+-------+-----+-----+
        | John       | Smith | Esq | 22  |
        +------------+-------+-----+-----+
        | Harry              | MD  | 56  |
        +------------+-------+-----+-----+
      TABLE
    end
  end

  def fixture(name)
    File.read(File.expand_path(name, File.join(__dir__, "fixtures")))
  end
end
