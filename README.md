# Physical

This is a small library to describe packages (that could, potentially, be mailed) and
structures that store packages.

### Packages

A `Physical::Package` represents a package. It has an ID, dimensions, and weight.

The `Package` takes its dimensions from its `container` object, usually a `Physical::Box`.
It also has a `Set` of `Physical::Item`s that together with the container make up everything
about the package.

All containers are thought to be `Cuboid`: they have three dimensions and a weight.

The weight of a `Package` is the weight of its container plus the weight of all items plus
the weight of any void fill.

By default, the `Physical::Box` container is infinitely large. In order to limit the size
of the container, simply give it dimensions.

### Structures

A `Physical::Structure` represents a pallet, skid, rack, or some other collection of packages.
Similar to a `Package`, it has an ID, dimensions, and weight.

The `Structure` takes its dimensions from its `container` object, usually a `Physical::Pallet`.
It also has an `Array` of `Physical::Package`s that together with the container make up
everything about the structure.

The weight of a `Structure` is the weight of its container plus the weight of all packages.
Structures do not have void fill.

By default, the `Physical::Pallet` container is infinitely large. In order to limit the size
of the container, simply give it dimensions.

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

### Basic package

A basic package has no items and is simply assigned a weight and dimensions. Weights must
be specified as `Measured::Weight` objects. Dimensions must be specified as an array of
`Measured::Length` objects.

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
The package's weight and dimensions are retrieved using the `#weight` and `#dimensions`
attribute reader methods.

### Package dimensions

The length, width and height of a package are defined as the dimension array's first,
second, and third argument, respectively. For the package from the previous example,
`#length` will be 3 inches, `#width` will be 4 inches, and `#height` will be 5 inches.

### Packages with items

The following example is a somewhat more elaborate package: we know the items inside!
`Physical::Item` objects are `Cuboid`, so they have three dimensions and a weight. They also
have a `properties` hash that can hold things like any hazardous properties that might
impede shipping.

```ruby
item_one = Physical::Item.new(
  id: '12345',
  dimensions: [
    Measured::Length(2, :inch),
    Measured::Length(4, :inch),
    Measured::Length(5, :inch)
  ],
  weight: Measured::Weight(5, :g),
)

item_two = Physical::Item.new(
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
  items: [item_one, item_two]
)
```

This package has no defined container. This means we assume a box that is infinitely large, and
that has zero weight. Thus the weight of this `package_with_items` will be 28 grams
(5 g + 23 g = 28 g).

### Packages with boxes

A package also has a container that wraps it. This container is assumed to be a `Cuboid`, too -
but one that has inner dimensions, and a weight that is it's own weight which must be added to
item weights in order to find out the total weight of a package.

```ruby
container = Physical::Box.new(
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

If you create a container and omit the inner dimensions, we will assume that the container's inner
dimensions are equal to its outer dimensions. This will, in many cases, be good enough (but in some
cases you'll need the extra precision).

### Calculating void fill

For an elaborate package with a container box and items, we still cannot find out the full weight
of the package  without taking into account void fill (styrofoam, bubble wrap or crumpled newspaper
maybe). We can instruct the  package to fill up all the volume not used up by items with void fill.
You can pass the density as a `Measured::Weight` object that refers to the weight of 1 cubic
centimeter of void fill:

```ruby
package = Physical::Package.new(
  id: "my_package",
  container: container,
  items: [item_one, item_two],
  void_fill_density: Measured::Weight(0.007, :g)
)
```

In this case, the package's weight will be slightly above the sum of container weight and the
sum  of item weights, as we incorporate the approximate weight of the void fill material:

```ruby
package.weight
=> #<Measured::Weight: 1380.75262208 #<Measured::Unit: g (gram, grams)>>

package.remaining_volume
=> #<Measured::Volume: 1107.51744 #<Measured::Unit: ml (milliliter, millilitre, milliliters, millilitres) 1/1000 l>>
```
### Basic structure

A basic structure has no packages and is simply assigned a weight and dimensions. Weights must
be specified as `Measured::Weight` objects. Dimensions must be specified as an array of
`Measured::Length` objects.

```ruby
Physical::Structure.new(
  weight: Measured::Weight(1, :pound),
  dimensions: [
    Measured::Length(48, :inch),
    Measured::Length(48, :inch),
    Measured::Length(96, :inch)
  ]
)
```
The structure's weight and dimensions are retrieved using the `#weight` and `#dimensions`
attribute reader methods.

### Structure dimensions

The length, width and height of a structure are defined as the dimension array's first,
second, and third argument, respectively. For the structure from the previous example,
`#length` will be 48 inches, `#width` will be 48 inches, and `#height` will be 96 inches
(the approximate dimensions of a pallet).

### Structures with packages

The following example is a somewhat more elaborate structure: we know the packages inside!
`Physical::Package` objects are `Cuboid`, so they have three dimensions and a weight. They also
have a `properties` hash that can hold things like any hazardous properties that might
impede shipping.

```ruby
package_one = Physical::Package.new(
  id: '12345',
  dimensions: [
    Measured::Length(2, :inch),
    Measured::Length(4, :inch),
    Measured::Length(5, :inch)
  ],
  weight: Measured::Weight(1, :kg),
)

package_two = Physical::Package.new(
  id: "54321",
  dimensions: [
    Measured::Length(1, :cm),
    Measured::Length(1, :cm),
    Measured::Length(1, :cm)
  ],
  weight: Measured::Weight(23, :g)
)
```

You can initialize a structure with packages as follows:

```ruby
structure_with_packages = Physical::Structure.new(
  items: [package_one, package_two]
)
```

This structure has no defined container. This means we assume a pallet that is infinitely large,
and that has zero weight. Thus the weight of this `structure_with_packages` will be 1023 grams
(1 kg + 73 g = 1000 g + 23 g = 1023 g).

### Structures with pallets

A structure also has a container that wraps it. This container is assumed to be a `Cuboid`, too -
but one that has inner dimensions, and a weight that is it's own weight which must be added to
package weights in order to find out the total weight of a structure.

```ruby
container = Physical::Pallet.new(
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

If you create a container and omit the inner dimensions, we will assume that the container's inner
dimensions are equal to its outer dimensions. This will, in many cases, be good enough (but in some
cases you'll need the extra precision).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to
run the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/friendlycart/physical.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Physical project’s codebases, issue trackers, chat rooms and
mailing lists is expected to follow the [code of conduct](https://github.com/friendlycart/physical/blob/main/CODE_OF_CONDUCT.md).
