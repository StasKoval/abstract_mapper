# encoding: utf-8

class AbstractMapper

  class Rules

    # Base class for optimization rules
    #
    # @abstract
    #
    # @api private
    #
    class Base

      # @private
      def self.composer
        :identity
      end
      private_class_method :composer

      # The transformation function that applies the rule to the array of nodes
      #
      # @return [Transproc::Function]
      #
      def self.transproc
        Functions[composer, proc { |*nodes| new(*nodes).call }]
      end

      # @!attribute [r] nodes
      #
      # @return [Array<AbstractMapper::AST::Node>]
      #   Either one or two nodes to be optimized
      #
      attr_reader :nodes

      # Initializes the rule for a sole node, or a pair of consecutive nodes
      #
      # @param [Array<AbstractMapper::AST::Node>] nodes
      #
      # @return [AbstractMapper::Rules::Base]
      #
      def initialize(*nodes)
        @nodes = nodes
        IceNine.deep_freeze(self)
      end

      # Checks if optimization is needed for the node(s)
      #
      # @return [Boolean]
      #
      def optimize?
      end

      # Returns the optimized node(s)
      #
      # @return [Object]
      #
      def optimize
        nodes
      end

      # Returns the result of the rule applied to the initialized [#nodes]
      #
      # @return [Array<AbstractMapper::AST::Node>]
      #
      def call
        optimize? ? [optimize].flatten.compact : nodes
      end

    end # class Base

  end # class Rules

end # class AbstractMapper
