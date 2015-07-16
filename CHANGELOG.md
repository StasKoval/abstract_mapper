## Prepared for the next version

### Changed

* Removed force ordering of rules (nepalez)

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

[Compare v0.0.1...HEAD](https://github.com/nepalez/abstract_mapper/compare/v0.0.1...HEAD)

## v0.0.1 2015-07-04

This is the first published version of the gem.
