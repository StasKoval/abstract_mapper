# encoding: utf-8

class AbstractMapper

  # The configurable container of domain-specific DSL commands and rules
  # along with corresponding AST builder and optimizer
  #
  # @api private
  #
  class Settings

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

    # @!scope class
    # @!method new(&block)
    # Creates a domain-specific settings with commands and rules initialized
    # from inside a block
    #
    # @param [Proc] block
    #
    # @return [AbstractMapper::Settings]

    # @private
    def initialize(&block)
      __set_rules__
      __set_commands__
      __configure__(&block)
      __set_builder__
      __set_optimizer__
      IceNine.deep_freeze(self)
    end

    private

    def rule(value)
      fn = Functions[:subclass?, Rule]
      fail Errors::WrongRule.new(value) unless fn[value]
      @rules = rules << value
    end

    def command(name, node)
      fn = Functions[:subclass?, Node]
      fail Errors::WrongNode.new(node) unless fn[node]
      @commands = commands << [name, node]
    end

    def __set_rules__
      @rules = Rules.new
    end

    def __set_commands__
      @commands = Commands.new
    end

    def __configure__(&block)
      instance_eval(&block) if block_given?
    end

    def __set_builder__
      @builder = Class.new(Builder)
      builder.commands = commands
    end

    def __set_optimizer__
      @optimizer = Optimizer.new(rules)
    end

  end # class Settings

end # class AbstractMapper
