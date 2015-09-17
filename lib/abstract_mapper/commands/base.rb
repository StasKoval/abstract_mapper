# encoding: utf-8

class AbstractMapper

  class Commands

    # Describes the command of the mapper
    #
    # Method `#call` builds a correspodning node for the AST.
    #
    # @api private
    #
    class Base

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
      # @return [AbstractMapper::Commands::Base]

      # @private
      def initialize(name, klass, converter = nil)
        @name = name.to_sym
        @klass = klass
        @branch = Functions[:subclass?, AST::Branch][klass]
        @converter = converter || proc { |args = {}| args }
        IceNine.deep_freeze(self)
      end

      # Builds the AST node
      #
      # @param [Object, Array] args
      #   The argument of the command
      # @param [Proc] block
      #
      # @return [AbstractMapper::AST::Node]
      #
      def call(*args, &block)
        block = nil if @branch
        klass.new(converter.call(*args), &block)
      end

    end # class Base

  end # class Commands

end # class AbstractMapper
