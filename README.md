# Physical

This is a small library to describe Packages (that could, potentially, be mailed).

A `Physical::Package` represents a package. It has and ID, dimensions, and a weight.

The `Package` takes it's dimensions from its `container` object, usually a `Physical::Box`.
It also has a `Set` of `Physical::Item`s that together make with the container make up everything
about the Package.

All things are thought to be cuboid: They have three dimensions, and a weight.

The weight of a `Package` is the weight of it's container plus the weight of all items, plus the weight
of any void fill.

By default, the `Physical::Box` is infinitely large. In order to limit the size of the Box, simply give it
dimensions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'physical'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install physical

## Usage

```ruby
one_sku = Physical::Item.new(
  id: '12345',
  dimensions: [2, 4, 5],
  dimension_unit: :inch,
  weight: 1,
  weight_unit: :kg
)

two_sku = Physical::Item.new(
  id: "54321",
  dimensions: [1, 1, 1],
  dimension_unit: :cm,
  weight: 2.3,
  weight_unit: :g
)

my_carton = Physical::Box.new(
  dimensions: [10, 15, 15],
  dimension_unit: :cm,
  weight: 0.8,
  weight_unit: :lbs
)

package = Physical::Package.new(
  id: "my_package",
  container: my_carton,
  items: [one_sku, two_sku],
  void_fill_density: 0.007
)

package.weight
=> #<Measured::Weight: 1376.32851808 #<Measured::Unit: g (gram, grams)>>

package.remaining_volume
=> #<Measured::Volume: 1593.51744 #<Measured::Unit: ml (milliliter, millilitre, milliliters, millilitres) 1/1000 l>>
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mamhoff/physical. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Physical project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/physical/blob/master/CODE_OF_CONDUCT.md).
