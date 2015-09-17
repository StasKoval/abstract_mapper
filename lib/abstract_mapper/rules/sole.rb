# encoding: utf-8

class AbstractMapper

  class Rules

    # The abstract class that describes the rule to be applied to sole nodes.
    #
    # The subclass should implement two instance methods:
    #
    # * `#optimize?` to check if the optimization should be applied to the node
    # * `#optimize` that should return the optimized node
    #
    # @example
    #   class RemoveEmptyList < AbstractMapper::Rules::Sole
    #     def optimize?
    #       node.is_a?(List) && node.empty?
    #     end
    #
    #     def optimize
    #     end
    #   end
    #
    # @abstract
    #
    # @api public
    #
    class Sole < Base

      # @private
      def self.composer
        :filter
      end
      private_class_method :composer

      # @!attribute [r] node
      #
      # @return [AbstractMapper::Node] The node to be optimized
      #
      attr_reader :node

      # @!scope class
      # @!method new(node)
      # Creates a rule applied to the sole node
      #
      # @param [AbstractMapper::Node] node
      #
      # @return [AbstractMapper::Rules::Base]

      # @private
      def initialize(node)
        @node = node
        super
      end

    end # class Sole

  end # class Rule

end # class AbstractMapper
