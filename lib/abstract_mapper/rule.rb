# encoding: utf-8

class AbstractMapper

  # Base class for nodes optimization rules
  #
  # @abstract
  #
  # @api private
  #
  class Rule

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
    # @return [Array<AbstractMapper::Node>]
    #   Either one or two nodes to be optimized
    #
    attr_reader :nodes

    # @!scope class
    # @!method new(*nodes)
    # Creates the rule for a sole node, or a pair of consecutive nodes
    #
    # @param [Array<AbstractMapper::Node>] nodes
    #
    # @return [AbstractMapper::Rule]

    # @private
    def initialize(*nodes)
      @nodes = nodes.freeze
      freeze
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
    # @return [Array<AbstractMapper::Node>]
    #
    def call
      optimize? ? [optimize].flatten.compact : nodes
    end

  end # class Rule

end # class AbstractMapper
