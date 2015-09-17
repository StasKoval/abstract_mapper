## v0.1.0 to be released

### Changed (backward-incompatible)

* Rules are moved to the `Rules` namespace (nepalez):
  - `Rule`     -> `Rules::Base`
  - `SoleRule` -> `Rules::Sole`
  - `PairRule` -> `Rules::Pair`

### Internal

* Extracted `Attributes` to the external gem 'attributes_dsl' (nepalez)
* Renamed `Command` to `Commands::Base` (nepalez)

[Compare v0.0.2...HEAD](https://github.com/nepalez/abstract_mapper/compare/v0.0.2...HEAD)

## v0.0.2 2015-08-06

### Added

* Coersion of command arguments into the the node's attributes (nepalez)

### Changed

* Removed force ordering of rules (nepalez)
* Nodes takes hash of attributes instead of array (nepalez)

### Deleted

* Removed shared examples for mapper. The mapper should be specified by integration tests (nepalez)

### Bugs fixed

* Fixed the `:transforming_immutable_data` shared examples so that it can deal with singleton inputs (nepalez)
* Fixed the `:mapping_immutable_input` shared examples so that it can deal with singleton inputs (nepalez)
* Fixed typo in `WrongRule` exception message (nepalez)

### Internal

* Switched to `transproc` gem v0.3.0 (nepalez)
* Added the `Functions#identity` pure function (nepalez)
* Made the `Rule` to fully implement the interface, including method `.transproc`, `#optimize?`, `#optimize` that by default change nothing (nepalez)
* Made the `.composer` setting private for all rules (`Rule`, `SoleRule`, `PairRule`) (nepalez)
* Switched to 'ice_nine' gem for freezing instances deeply (nepalez)
* Added `ice_double` feature to specs (nepalez)
* Added `AbstractMapper::Command` that can convert arguments of the command to the node's (nepalez)
* Switched to `virtus` attributes (nepalez)

[Compare v0.0.1...v0.0.2](https://github.com/nepalez/abstract_mapper/compare/v0.0.1...v0.0.2)

## v0.0.1 2015-07-04

This is the first published version of the gem.
