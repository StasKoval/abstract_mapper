# encoding: utf-8

class AbstractMapper

  require_relative "commands/base"

  # Collection of DSL commands used by the builder
  #
  # @api private
  #
  class Commands

    # @!scope class
    # @!method new(registry = {})
    # Creates an immutable collection of commands
    #
    # @param [Hash] registry
    #
    # @return [Faceter::Commands]

    # @private
    def initialize(registry = {})
      @registry = registry.dup
      IceNine.deep_freeze(self)
    end

    # Returns a new immutable registry with added command name and type
    #
    # @param [[Symbol, Class, Proc]] other
    #
    # @return [undefined]
    #
    def <<(other)
      command = Commands::Base.new(*other)
      self.class.new @registry.merge(command.name => command)
    end

    # Returns the registered command by name
    #
    # @param [#to_sym] name The name of the command
    #
    # @return [AbstractMapper::Commands::Base]
    #
    # @raise [AbstractMapper::Errors::UnknownCommand]
    #   When unknown command is called
    #
    def [](name)
      @registry.fetch(name.to_sym) { fail(Errors::UnknownCommand.new name) }
    end

  end # class Commands

end # class AbstractMapper
