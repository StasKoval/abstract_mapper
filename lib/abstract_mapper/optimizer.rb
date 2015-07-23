# encoding: utf-8

class AbstractMapper

  # Optimizes the immutable abstract syntax tree (AST) using comfigurable
  # collection of applicable rules.
  #
  # @api private
  #
  class Optimizer

    # @!attribute [r] rules
    #
    # @return [AbstractMapper::Rules]
    #   The collection of applicable optimization rules
    #
    attr_reader :rules

    # @!scope class
    # @!method new(rules = Rules.new)
    # Creates the optimizer
    #
    # @param [AbstractMapper::Rules] rules
    #   The collection of applicable optimization rules
    #
    # @return [AbstractMapper::Optimizer]

    # @private
    def initialize(rules)
      @rules = rules
      IceNine.deep_freeze(self)
    end

    # Recursively optimizes the AST from root to leafs
    #
    # @param [AbstractMapper::Branch] tree
    #
    # @return [AbstractMapper::Branch]
    #
    def update(tree)
      return tree unless tree.is_a? Branch
      new_tree = tree.update { rules[tree] }
      new_tree.update { new_tree.map(&method(:update)) }
    end

  end # class Optimizer

end # class AbstractMapper
