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
class User < ActiveRecord::Base
    acts_as_temptable :sql => lambda { |param| 
        "select u.*,g.* from users u join games g on u.game_id=g.id where u.league_id=#{param[:league_id]}" 
    }
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ajbdev/temptable.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

