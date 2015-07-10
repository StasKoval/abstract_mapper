# encoding: utf-8

class AbstractMapper

  # Registry of DSL commands used by the builder
  #
  # @api private
  #
  class Commands

    # @!attribute [r] registry
    #
    # @return [Hash<Symbol => Class>]
    #   The registry of command names, pointing to types of the nodes,
    #   that should be built for adding to AST
    #
    attr_reader :registry

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
    # @param [[Symbol, Class]] other
    #
    # @return [undefined]
    #
    def <<(other)
      name, node = other
      self.class.new registry.merge(name.to_sym => node)
    end

    # Builds a node by the name of DSL command
    #
    # Skips the block if a registered node is a branch
    #
    # @param [#to_sym] name The name of the command
    # @param [Object, Array] args The command's arguments
    # @param [Proc] block
    #   The block to be passed to the constructor of the simple node
    #
    # @raise [AbstractMapper::Errors::UnknownCommand]
    #   When unknown command is called
    #
    def [](name, *args, &block)
      type   = get(name)
      branch = Functions[:subclass?, Branch][type]
      branch ? type.new(*args) : type.new(*args, &block)
    end

    private

    def get(name)
      registry.fetch(name.to_sym) { fail(Errors::UnknownCommand.new name) }
    end

  end # class Commands

end # class AbstractMapper
