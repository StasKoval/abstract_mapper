# encoding: utf-8

class AbstractMapper

  # Describes the command of the mapper
  #
  # Every command has a name, a node that is added to the AST and the function,
  # that converts command attributes into the node's.
  #
  # Method `#call` builds a correspodning node for the AST.
  #
  # @api private
  #
  class Command

    # @!attribute [r] name
    #
    # @return [Symbol] The name of the DSL command
    #
    attr_reader :name

    # @!attribute [r] klass
    #
    # @return [Class] The class of the node to be created
    #
    attr_reader :klass

    # @!attribute [r] converter
    #
    # @return [#call] The converter of the command's arguments into the node's
    #
    attr_reader :converter

    # @!scope class
    # @!method new(name, klass, converter)
    # Creates the named command for node klass and arguments converter
    #
    # @param [#to_sym] name The name of the DSL command
    # @param [Class] klass The klass of the node to be created
    # @param [#call] converter The function that coerces attributes
    #
    # @return [AbstractMapper::Command]

    # @private
    def initialize(name, klass, converter = nil)
      @name = name.to_sym
      @klass = klass
      @branch = Functions[:subclass?, Branch][klass]
      @converter = converter || -> *args { args }
      IceNine.deep_freeze(self)
    end

    # Builds the AST node
    #
    # @param [Object, Array] attributes
    # @param [Proc] block
    #
    # @return [AbstractMapper::Node]
    #
    def call(*attributes, &block)
      block = nil if @branch
      klass.new(*converter.call(*attributes), &block)
    end

  end # class Command

end # class AbstractMapper
