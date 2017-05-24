require "spec_helper"

require "capybara_table"
require "capybara_table/rspec"

describe CapybaraTable, type: :feature do
  let(:simple_table) { Capybara.string(fixture("simple_table.html")) }
  let(:table_with_colspan) { Capybara.string(fixture("table_with_colspan.html")) }

  describe :table do
    it "finds a table by caption" do
      expect(table_with_colspan).to have_selector(:table, "People")
      expect(table_with_colspan).not_to have_selector(:table, "People", exact: true)
      expect(table_with_colspan).not_to have_selector(:table, "WRONG")
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

    it "supports colspans" do
      expect(table_with_colspan).to have_table_row("First Name" => "Jonas", "Age" => "31")
      expect(table_with_colspan).not_to have_table_row("First Name" => "Jonas", "Age" => "44")
      expect(table_with_colspan).not_to have_table_row("First Name" => "Jonas", "Last Name" => "31")

      expect(table_with_colspan).to have_table_row("First Name" => "John", "Last Name" => "Smith", "Age" => "22")
      expect(table_with_colspan).not_to have_table_row("Age" => "Esq")
      expect(table_with_colspan).not_to have_table_row("Last Name" => "Esq")

      expect(table_with_colspan).to have_table_row("First Name" => "Harry", "Age" => "56")
    end
  end

  def fixture(name)
    File.read(File.expand_path(name, File.join(__dir__, "fixtures")))
  end
end
