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

    # Default attributes for the node
    #
    # @return [Hash]
    #
    def self.attributes
      @attributes ||= {}
    end

    # Declares the attribute
    #
    # @param [#to_sym] name
    # @param [Hash] options
    # @option options [Object] :default
    #
    # @return [undefined]
    #
    def self.attribute(name, **options)
      attributes[name.to_sym] = options[:default]
      define_method(name) { attributes[name.to_sym] }
    end

    # @!attribute [r] block
    #
    # @return [Proc] The block given to initializer
    #
    attr_reader :block

    # @!attribute [r] attributes
    #
    # @return [Hash] The attributes of the node
    #
    attr_reader :attributes

    # @private
    def initialize(attributes = {}, &block)
      @attributes = Functions[:restrict, self.class.attributes][attributes]
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
