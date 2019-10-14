# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

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
