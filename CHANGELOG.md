# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## [0.6.0] - 2025-08-14

### Changed
- Require Ruby >= 3.0
- Upgrade `measured` dependency to `~> 3.0` (bundled as 3.2.1)

## [0.5.1] - 2023-12-19

### Changed
- Better pallet deprecations [#32]

## [0.5.0] - 2023-12-19

### Added
- Introduce `Physical::Structure` class [#31]

### Changed
- Use legitimate state/zip in location factory [#30]

## [0.4.9] - 2023-08-02

### Added
- Extract cuboid property handling into mixin [#25]
- Add properties to `Physical::Location` [#26]
- Add pallets to `Physical::Shipment` [#29]

### Changed
- Faster package weight and volume calculations [#23]

## [0.4.8] - 2023-03-21

### Added
- Add `#items_value` to `Physical::Package` [#21]

## [0.4.7] - 2022-12-14

### Changed
- Relax Dry::Types dependency to "~> 1.0" [#20]

## [0.4.5] - 2022-09-28

### Added
- Add `Physical::Pallet` class [#12]
- Convenience methods for weight, volume, and fill [#15]
- Add inner dimensions for `Pallet` class [#16]

### Changed
- Fix Ruby 2.7 deprecation warnings [#3]
- Set rounding mode for Money gem [#6]
- Bump Rake version [#10]
- Ruby 3 support [#18]

## [0.4.4] - 2019-10-29

### Added
- Add `#sku`, `#cost` and `#description` to `Physical::Item`

## [0.4.3] - 2019-10-14

### Added
- Add `#latitude` and `#longitude` to `Physical::Location`

## [0.4.2] - 2019-09-04

### Changed
- Relax `Measured` Gem dependency

## [0.4.1] - 2019-07-15

### Added
- Add `max_weight` to `Physical::Package`

## [0.4.0] - 2019-07-10

### Added
- `Measured::Density` Type and density calculations [@tvdeyen](https://github.com/mamhoff/physical/pull/19)
- Use `Measured::Density` Type when initializing `Physical::Package#void_fill_density` [@mamhoff](https://github.com/mamhoff/physical/pull/22)
