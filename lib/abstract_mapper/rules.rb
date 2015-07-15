# encoding: utf-8

class AbstractMapper

  # Registry of DSL rules applicable to nodes of AST
  #
  # @api private
  #
  class Rules

    # @!attribute [r] registry
    #
    # @return [Array<AbstractMapper::SoleRule>] list of rules applicable to AST
    #
    attr_reader :registry

    # @!scope class
    # @!method new(registry)
    # Creates a registry with array of rules
    #
    # @param [Array<AbstractMapper::SoleRule>] registry Array of rules
    #
    # @return [AbstractMapper::Rules]

    # @private
    def initialize(registry = [])
      @registry  = registry.dup
      @transproc = registry.map(&:transproc).inject(:>>)
      IceNine.deep_freeze(self)
    end

    # Returns the copy of current registry with the new rule added
    #
    # @param [AbstractMapper::SoleRule] other
    #
    # @return (see #new)
    #
    def <<(other)
      self.class.new(registry + [other])
    end

    # Applies all the registered rules to the array of nodes
    #
    # @param [Array<AbstractMapper::Node>] nodes
    #
    # @return [Array<AbstractMapper::Node>] The optimized array of nodes
    #
    def [](nodes)
      @transproc ? @transproc[nodes] : nodes
    end

  end # class Rules

end # class AbstractMapper
