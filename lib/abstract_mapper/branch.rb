# encoding: utf-8

class AbstractMapper

  # A special type of the composed node, that describes transformation,
  # applied to some level of nested input.
  #
  # Unlike the simple node, describing a transformation of data, the
  # branch carries a collection of subnodes along with methods to [#update]
  # itself with the same attributes and different subnodes.
  #
  # Tne branch only stores subnodes and composes transformations.
  # Its has no access to DSL and knows neither how to build a tree
  # (see [AbstractMapper::Builder]), nor how to optimize it later
  # (see [AbstractMapper::Optimizer]).
  #
  # @api public
  #
  class Branch < Node

    include Enumerable

    # @!scope class
    # @!method new(*attributes, &block)
    # Creates a new branch
    #
    # @param [Object, Array<Object>] attributes
    #   The list of type-specific attributes of the branch
    # @param [Proc] block
    #   The block that returns an array of subnodes for the branch
    #
    # @return [Branch::Node]

    # @private
    def initialize(attributes = {})
      @subnodes = block_given? ? yield : []
      super(attributes, &nil)
    end

    # Returns a new branch of the same type, with the same attributes,
    # but with a different collection of subnodes, transmitted by the block.
    #
    # @example
    #   branch = Branch.new(:foo)
    #   # => <Branch(:foo) []>
    #   branch.update { Node.new(:bar) }
    #   # => <Branch(:foo) [<Node(:bar)>]>
    #
    # @param [Proc] block
    #   The block that should return an array of subnodes for the branch
    #
    # @return [AbstractMapper::Branch]
    #
    # @yield block
    #
    def update
      self.class.new(attributes) { yield }
    end

    # @!method each
    # Returns the enumerator for subnodes
    #
    # @return [Enumerator]
    #
    def each(&block)
      @subnodes.each(&block)
    end

    # Returns a new branch with the other node added to its subnodes
    #
    # @param [AbstractMapper::Node] other
    #
    # @return [AbstractMapper::Branch]
    #
    def <<(other)
      update { entries << other }
    end

    # The composition of transformations from all subnodes of the branch
    #
    # To be reloaded by the subclasses to apply the composition to
    # a corresponding level of nested data.
    #
    # @return [Transproc::Function]
    #
    # @abstract
    #
    def transproc
      map(&:transproc).inject(:>>)
    end

    # Adds subnodes to the default description of the branch
    #
    # @return [String]
    #
    def to_s
      "#{super} [#{map(&:inspect).join(", ")}]"
    end

    # Checks equality of branches by type, attributes and subnodes
    #
    # @param [Other] other
    #
    # @return [Boolean]
    #
    def eql?(other)
      super && entries.eql?(other.entries)
    end

    private

    # Substitutes the name of the class by the special name "Root"
    # to describe the root node of AST.
    def __name__
      instance_of?(Branch) ? "Root" : super
    end

  end # class Branch

end # class AbstractMapper
