require "spec_helper"

require "capybara_table"
require "capybara_table/rspec"

describe CapybaraTable, type: :feature do
  describe :table_row do
    let(:simple_table) { Capybara.string(fixture("simple_table.html")) }

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
  end

  def fixture(name)
    File.read(File.expand_path(name, File.join(__dir__, "fixtures")))
  end
end
