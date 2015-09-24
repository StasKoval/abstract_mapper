# encoding: utf-8

class AbstractMapper

  # The configurable container of domain-specific DSL commands and rules
  # along with corresponding AST builder and optimizer
  #
  # @api private
  #
  class Settings

    include Immutability

    # @!attribute [r] commands
    #
    # @return [AbstractMapper::Commands]
    #   The collection of registered DSL commands
    #
    attr_reader :commands

    # @!attribute [r] rules
    #
    # @return [AbstractMapper::Rules]
    #   The collection of registered optimization rules
    #
    attr_reader :rules

    # @!attribute [r] optimizer
    #
    # @return [AbstractMapper::Optimizer]
    #   The optimizer with domain-specific rules
    #
    attr_reader :optimizer

    # @!attribute [r] builder
    #
    # @return [Class] The builder class with domain-specific commands
    #
    attr_reader :builder

    # Initializes a domain-specific settings with commands and rules
    # being set in the block.
    #
    # @param [Proc] block
    #
    # @yield the block with settings for commands and rules
    #
    def initialize(rules = Rules.new, commands = Commands.new, &block)
      @rules    = rules
      @commands = commands
      configure(&block)
    end

    # Returns a new class with rules and commands added from the block
    # to the existing ones
    #
    # @return [AbstractMapper::Settings]
    #
    # @yield the block with settings for commands and rules
    #
    def update(&block)
      self.class.new(rules, commands, &block)
    end

    private

    def rule(value)
      fn = Functions[:subclass?, Rules::Base]
      fail Errors::WrongRule.new(value) unless fn[value]
      @rules = rules << value
    end

    def command(name, node, &block)
      fn = Functions[:subclass?, AST::Node]
      fail Errors::WrongNode.new(node) unless fn[node]
      @commands = commands << [name, node, block]
    end

    def configure(&block)
      instance_eval(&block) if block_given?
      @builder = Class.new(Builder)
      builder.commands = commands
      @optimizer = Optimizer.new(rules)
    end

  end # class Settings

end # class AbstractMapper
