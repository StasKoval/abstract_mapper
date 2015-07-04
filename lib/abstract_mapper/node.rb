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

    # @!attribute [r] attributes
    #
    # @return [Array] The list of node-specific attributes
    #
    attr_reader :attributes

    # @!attribute [r] block
    #
    # @return [Proc] The block given to initializer
    #
    attr_reader :block

    # @private
    def initialize(*attributes, &block)
      @attributes = attributes.freeze
      @block      = block
      freeze
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

    private

    def __name__
      self.class.name.split("::").last
    end

    def __attributes__
      "(#{attributes.map(&:inspect).join(", ")})" if attributes.any?
    end

  end # class Node

end # class AbstractMapper
