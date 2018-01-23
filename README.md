# CapybaraTable

Some neat Capybara selectors and matchers for working with HTML tables.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara_table'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara_table

If you're using RSpec, require the matchers:

```
require "capybara_table/rspec"
```

Otherwise

## Usage



If you have a table like this:

``` html
<table>
  <caption>People</caption>
  <tr>
    <th>First Name</th>
    <th>Last Name</th>
    <th>Age</th>
  </tr>
  <tr>
    <td>Jonas</td>
    <td>Nicklas</td>
    <td>31</td>
  </tr>
  <tr>
    <td colspan="2">John</td>
    <td>22</td>
  </tr>
</table>
```

Then you can do this

``` ruby
# find a table by caption
find(:table, "People") # by caption

# find a table row by its headers, even works with colspans!
# (note the extra hash at the end)
find(:table_row, {"First Name" => "Jonas", "Last Name" => "Nicklas"}, {})

# Assert on a table row with RSpec
expect(find(:table, "People")).to have_table_row("First Name" => "Jonas", "Last Name" => "Nicklas")

# Assert on a table row with MiniTest
within :table, "People" do
  assert_selector(:table_row, {"First Name" => "Jonas", "Last Name" => "Nicklas"}, {})
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

