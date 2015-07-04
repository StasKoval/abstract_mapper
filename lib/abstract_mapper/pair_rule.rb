# encoding: utf-8

class AbstractMapper

  # The base class for rules to be applied to pairs of nodes.
  #
  # The subclass should implement two instance methods:
  #
  # * `#optimize?` to check if the optimization should be applied to the nodes
  # * `#optimize` that should return the merged node
  #
  # @example
  #   class MergeConsecutiveLists < AbstractMapper::PairRule
  #     def optimize?
  #       left.is_a?(List) & right.is_a?(List)
  #     end
  #
  #     def optimize
  #       List.new { left.entries + right.entries }
  #     end
  #   end
  #
  # @abstract
  #
  # @api public
  #
  class PairRule < Rule

    # @private
    def self.composer
      :compact
    end
    private_class_method :composer

    # @!attribute [r] node
    #
    # @return [AbstractMapper::Node] The left node in the pair to be optimized
    #
    attr_reader :left

    # @!attribute [r] node
    #
    # @return [AbstractMapper::Node] The right node in the pair to be optimized
    #
    attr_reader :right

    # @!scope class
    # @!method new(node)
    # Creates a rule applied to the sole node
    #
    # @param [AbstractMapper::Node] node
    #
    # @return [AbstractMapper::Rule]

    # @private
    def initialize(left, right)
      @left  = left
      @right = right
      super
    end

  end # class PairRule

end # class AbstractMapper
