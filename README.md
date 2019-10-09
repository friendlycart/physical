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

### Basic Package

A basic Package has no items and is simply assigned a weight and dimensions. Weights and Dimensions have to be given as `Measured::Weight` or as an Array of `Measured::Length` objects:

```ruby
Physical::Package.new(
  weight: Measured::Weight(1, :pound),
  dimensions: [
    Measured::Length(3, :inch),
    Measured::Length(4, :inch),
    Measured::Length(5, :inch)
  ]
)
```
You will be able to retrieve the package's weight and dimensions using the `#weight` and `#dimensions` attribute reader methods.

### Convenience methods

The length, width and height of a package are defined as the dimension array's first, second, and third argument, respectively. For the package from the previous example, `package.length` will be 3 inches, `package.width` will be 4 inches, and `package.height` will be 5 inches.

### Packages with Items

The following example is a somewhat more elaborate package: We know the items inside! `Physical::Item` objects are Cuboids, so they have three dimensions and a weight. They also have a `properties` hash that can hold things like any hazardous properties that might impede shipping.


```ruby
sku_one = Physical::Item.new(
  id: '12345',
  dimensions: [
    Measured::Length(2, :inch),
    Measured::Length(4, :inch),
    Measured::Length(5, :inch)
  ],
  weight: Measured::Weight(1, :kg),
)

sku_two = Physical::Item.new(
  id: "54321",
  dimensions: [
    Measured::Length(1, :cm),
    Measured::Length(1, :cm),
    Measured::Length(1, :cm)
  ],
  weight: Measured::Weight(23, :g)
)
```

You can initialize a package with items as follows:

```ruby
package_with_items = Physical::Package.new(
  items: [sku_one, sku_two]
)
```

This package has no defined container. This means we assume a box that is infinitely large, and that has zero weight. Thus the weight of this `package_with_items` will be 1023 gram (1 kg + 23 g = 1000 g + 23 g).

### Packages with Boxes

A package also has a box that wraps it. This box is assumed to be a Cuboid, too - but one that has inner dimensions, and a weight that is it's own weight which must be added to any item's weight in order to find out the total weight of a package.

```ruby
my_carton = Physical::Box.new(
  dimensions: [
    Measured::Length(10, :cm),
    Measured::Length(15, :cm),
    Measured::Length(15, :cm)
  ],
  inner_dimensions: [
    Measured::Length(9, :cm),
    Measured::Length(14, :cm),
    Measured::Length(14, :cm)
  ],
  weight: Measured::Weight(350, :g),
)
```

If you create a carton and omit the inner dimensions, we will assume that the carton's inner dimensions are equal to its outer dimensions. This will, in many cases, be good enough (but in some you'll need the extra precision).

### Calculating Void Fill

For an elaborate package with a container box and items, we still cannot find out the full weight of the package without taking into account void fill (styrofoam, bubble wrap or crumpled newspaper maybe). We can instruct the package to fill up all the volume not used up by items with void fill. You can pass the density as a `Measured::Weight` object that refers to the weight of 1 cubic centimeter of void fill:

```ruby
package = Physical::Package.new(
  id: "my_package",
  container: my_carton,
  items: [sku_one, sku_two],
  void_fill_density: Measured::Weight(0.007, :g)
)
```

In this case, the package's weight will be slightly above the sum of carton weight and the sum of item weights, as we incorporate the approximate weight of the void fill material:

```ruby
package.weight
=> #<Measured::Weight: 1380.75262208 #<Measured::Unit: g (gram, grams)>>

package.remaining_volume
=> #<Measured::Volume: 1107.51744 #<Measured::Unit: ml (milliliter, millilitre, milliliters, millilitres) 1/1000 l>>
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/friendlycart/physical. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Physical project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/physical/blob/master/CODE_OF_CONDUCT.md).
