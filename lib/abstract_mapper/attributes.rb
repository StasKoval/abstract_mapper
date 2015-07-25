# encoding: utf-8

class AbstractMapper

  # Defines attributes along with the DSL for setting them
  #
  module Attributes

    # @private
    def self.included(klass)
      klass.__send__ :extend, DSL
    end

    # @!attribute [r] attributes
    #
    # @return [Hash] The initialized attributes
    #
    attr_reader :attributes

    # Initializes the instance with the hash of attributes
    #
    # @param [Hash] attributes
    #
    def initialize(attributes)
      @attributes = Functions[:restrict, self.class.attributes][attributes]
    end

    # Attributes DSL
    #
    module DSL

      # Makes a attributes inheritable
      #
      # @private
      #
      def inherited(klass)
        attributes.each { |key, value| klass.attribute key, default: value }
      end

      # Default attributes for the node
      #
      # @return [Hash]
      #
      def attributes
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
      def attribute(name, **options)
        attributes[name.to_sym] = options[:default]
        define_method(name) { attributes[name.to_sym] }
      end

    end # module DSL

  end # module Attributes

end # class AbstractMapper
