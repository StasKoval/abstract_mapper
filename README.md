Abstract Mapper
===============

[![Gem Version](https://img.shields.io/gem/v/abstract_mapper.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/abstract_mapper/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/abstract_mapper.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/abstract_mapper.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/nepalez/abstract_mapper.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/nepalez/abstract_mapper.svg)][inch]

[codeclimate]: https://codeclimate.com/github/nepalez/abstract_mapper
[coveralls]: https://coveralls.io/r/nepalez/abstract_mapper
[gem]: https://rubygems.org/gems/abstract_mapper
[gemnasium]: https://gemnasium.com/nepalez/abstract_mapper
[travis]: https://travis-ci.org/nepalez/abstract_mapper
[inch]: https://inch-ci.org/github/nepalez/abstract_mapper

Abstract syntax tree (AST) for domain-specific ruby mappers, based on the [transproc] gem.

No monkey-patching, no mutable instances. 100% [mutant]-covered.

[faceter]: https://github.com/nepalez/faceter
[mutant]: https://github.com/mbj/mutant
[transproc]: https://github.com/solnic/transproc

Installation
------------

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem "abstract_mapper"
```

Then execute:

```
bundle
```

Or add it manually:

```
gem install abstract_mapper
```

Usage
-----

The gem provides the metalevel of abstraction for defining specific DSL for mappers.

All you need to provide your own **mapper DSL** is:

* define DSL *commands* as a nodes, inherited from `AbstractMapper::Branch` and `AbstractMapper::Node`
* define DSL-specific *optimization rules* for merging consecutive nodes into more efficient ones

Let's suppose we need to provide a DSL for mappers, that can rename keys in array of tuples.
The following example represents an oversimplified version of the [faceter] gem.

### Define transformations (specific nodes of AST)

Every node should implement the `#transproc` method that transforms some input data to the output.

When you need attributes, assign them using [virtus] method `attribute`:

```ruby
require "abstract_mapper"

module Faceter
  # The node to define a transformation of every item of the array from input
  class List < AbstractMapper::Branch
    # The `List#super` is already composes subnodes. All you need is to define,
    # how the list should apply that composition to every item of the list
    #
    # Here the transformation from the transproc gem is used
    def transproc
      Transproc::ArrayTransformations[:map_array, super]
    end
  end

  # The node to define a renaming of keys in a tuple
  class Rename < AbstractMapper::Node
    attribute :keys

    def transproc
      Transproc::HashTransformations[:rename_keys, keys]
    end
  end
end
```

[virtus]: https://github.com/solnic/virtus

### Define optimization rules

AbstractMapper defines 2 rules `AbstractMapper::Rules::Sole` and `AbstractMapper::Rules::Pair`. The first one is applicable to every single node to check if it can be optimized by itself, the second one takes two consecutive nodes and either return them unchanged, or merges them into more time-efficient node.

For every rule you need to define two methods:

* `#optimize?` that defines if the rule is applicable to given node (or pair of nodes)
* `#optimize` that returns either array of changed nodes, or one node, or nothing when the node(s) should be removed from the tree

Use `#nodes` method to access nodes to be optimized. Base class `AbstractMapper::Rules::Sole` also defines the `#node` method, while `AbstractMapper::Rules::Pair` defines `#left` and `#right` for the corresponding parts of the pair.

```ruby
module Faceter
  # The empty lists are useless, because they does nothing at all
  class RemoveEmptyLists < AbstractMapper::Rules::Sole
    def optimize?
      node.is_a?(List) && node.empty?
    end

    def optimize
      # returns nothing
    end
  end

  # Two consecutive list branches are not a good solution, because they
  # iterates twice via the same array of items in the mapped data.
  #
  # That's why when we meet two consecutive lists, we have to merge them
  # into the one list, containing subnodes (entries) from both sources.
  class CompactLists < AbstractMapper::Rules::Pair
    def optimize?
      nodes.map { |n| n.is_a? List }.reduce(:&)
    end

    def optimize
      List.new { nodes.map(:entries).flatten }
    end
  end

  # Two consecutive renames can be merged
  class CompactRenames < AbstractMapper::Rules::Pair
    def optimize?
      nodes.map { |n| n.is_a? Rename }.reduce(:&)
    end

    def optimize
      Rename.new nodes.map(&:attributes).reduce(:merge)
    end
  end
end
```

### Register commands and rules

Now that both the nodes (transformers) and optimization rules are defined, its time to register them for the mapper.

You can coerce command argumets into node attributes. The coercer is expected to return a hash:

```ruby
module Faceter
  class Mapper < AbstractMapper
    configure do
      command :list, List

      # `:foo, to: :bar` becomes `{ keys: { foo: :bar } }`
      command :rename, Rename do |name, opts|
        { keys: { name => opts.fetch(:to) } }
      end

      rule RemoveEmptyLists
      rule CompactLists
      rule CompactRenames
    end
  end
end
```

### Use the mapper

Now we can create a concrete faceter-based mapper, using its DSL:

```ruby
require "faceter"

class MyMapper < Faceter::Mapper
  list do
    rename :foo, to: :bar
  end

  list do
    # this is useless, but we have a rule just for the case
  end

  list do
    rename :baz, to: :qux
  end
end

my_mapper = MyMapper.new

my_mapper.call [{ foo: :FOO, baz: :FOO }, { foo: :BAZ, baz: :BAZ }]
# => [{ bar: :FOO, qux: :FOO }, { bar: :BAZ, qux: :BAZ }]
```

All the rules are applied before initializing `my_mapper`, so the AST will be the following:

```ruby
my_mapper.tree
# => <Root [<List [<Rename(foo: :bar, baz: :qux)>]>]>
```

Testing
-------

The gem defines a collection of conventional *shared examples* to make [RSpec] tests simple and verbose.

See the list of available examples and how to use them in a [wiki page](https://github.com/nepalez/abstract_mapper/wiki/Shared-examples).

Links
-----

* [AbstractMapper API] contains some minor details.
* [Faceter] is an example of rich mapper.
* [Transproc] is a small gem that converts methods to pure transformers.
* [ROM] that heavily uses object mappers in its rich datastore adapters.

[AbstractMapper API]: http://www.rubydoc.info/gems/abstract_mapper
[Faceter]: https://github.com/nepalez/faceter
[Transproc]: https://github.com/solnic/transproc
[ROM]: http://rom-rb.org

Credits
-------

Many thanks to [Piotr Solnica](https://github.com/solnic) and all the [rom](https://gitter.im/rom-rb/chat) and [transproc](https://gitter.im/transproc/chat) contributors for the implementation of the rich data mapper DSL, and for the idea of even more abstract layer.

Compatibility
-------------

Tested under rubies [compatible to MRI 1.9.3+](.travis.yml).

Uses [RSpec] 3.0+ for testing and [hexx-suit] for dev/test tools collection.

[RSpec]: http://rspec.info
[hexx-suit]: https://github.com/nepalez/hexx-suit

Contributing
------------

* Read the [STYLEGUIDE](config/metrics/STYLEGUIDE)
* [Fork the project](https://github.com/nepalez/abstract_mapper)
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests for it
* Commit your changes (`git commit -am '[UPDATE] Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

License
-------

See the [MIT LICENSE](LICENSE).
