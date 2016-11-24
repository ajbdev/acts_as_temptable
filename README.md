# Temptable

Use a temporary table as the data source for your ActiveRecord model.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'temptable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install temptable

## Usage
First, add act_as_temptable to your ActiveRecord model.

```ruby
class UserGame < ActiveRecord::Base
    acts_as_temptable :sql => lambda { |param| 
        "select u.*,g.* from users u join games g on u.game_id=g.id where u.league_id=#{param[:league_id]}" 
    }
end
```
Second, invoke the temp_table method along with any parameters necessary to create the temp table.

```ruby
UserGame.temp_table :league_id => 552
```

This sets the active record model to query against the temp table. Any subsequent queries will run against the temp table.

The temp table is only created once when the temp_table method is executed, and only created again when the temp_table method is executed again.

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ajbdev/temptable.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

