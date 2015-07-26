# encoding: utf-8

class AbstractMapper

  # An immutable node of the abstract syntax tree (AST), that describes
  # either some "end-up" transformation, or a level of nested input data.
  #
  # Every node is expected to accept attributes and (possibly) block, and
  # implement `#transproc` that implements the `#call` method to
  # transform input data to the output.
  #
  # Nodes describe only the structure of AST, they know
  # neither how to build the tree with DSL (see [AbstractMapper::Builder]),
  # nor how to optimize it later (see [AbstractMapper::Optimizer]).
  #
  # @api public
  #
  class Node

    include Attributes # adds attributes and their DSL
    include Comparable

    # @!attribute [r] block
    #
    # @return [Proc] The block given to initializer
    #
    attr_reader :block

    # @private
    def initialize(_ = {}, &block)
      super
      @block      = block
      IceNine.deep_freeze(self)
    end

    # @!method transproc
    # The transformation function for the branch
    #
    # @return [Transproc::Function]
    #
    # @abstract
    #
    def transproc
      Functions[:identity]
    end

    # Returns a human-readable string representating the node
    #
    # @return [String]
    #
    def inspect
      "<#{self}>"
    end

    # Converts the node into string with its name and attributes
    #
    # @return [String]
    #
    def to_s
      "#{__name__}#{__attributes__}"
    end

    # Compares the node to another one by type and attributes
    #
    # @param [Object] other
    #
    # @return [Boolean]
    #
    def ==(other)
      other.instance_of?(self.class) && attributes.eql?(other.attributes)
    end
    alias_method :eql?, :==

    private

    def __name__
      self.class.name.split("::").last
    end

    def __attributes__
      return if attributes.empty?
      "(#{attributes.map { |k, v| "#{k}: #{v.inspect}" }.join(", ")})"
    end

  end # class Node

end # class AbstractMapper
