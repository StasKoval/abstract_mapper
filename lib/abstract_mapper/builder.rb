# encoding: utf-8

class AbstractMapper

  # Builds the immutable abstract syntax tree (AST) using DSL commands.
  #
  # @example
  #   Builder.update do
  #     field :user do     # DSL method
  #       add_prefix :user # DSL method for subtree
  #     end
  #   end
  #   # => <Root() [<Field(:user) [<AddPrefix(:user)>]>]>
  #
  # @api private
  #
  class Builder

    class << self

      # @!attribute [rw] commands
      #
      # @return [AbstractMapper::Commands] The registry of DSL commands
      #
      attr_writer :commands

      def commands
        @commands ||= AbstractMapper::Commands
      end

    end # eigenclass

    # Updates given node by adding its subnode from the block
    #
    # @param [AbstractMapper::Branch] node
    #   The root of the tree to be updated
    # @param [Proc] block
    #   The block with DSL commands for adding subnodes
    #
    # @return (see #tree)
    #
    def self.update(node = Branch.new, &block)
      new(node, &block).tree
    end

    # @!attribute [r] tree
    #
    # @return [AbstractMapper::Branch] The updated tree
    #
    attr_reader :tree

    # @!scope class
    # @!method new(node, &block)
    # Builds the AST by recursively adding new nodes, using the commands
    #
    # @param [AbstractMapper::Branch] node
    #   The root of the tree to be updated
    # @param [Proc] block
    #   The block with DSL commands for adding subnodes
    #
    # @return [AbstractMapper::Builder]

    # @private
    def initialize(node, &block)
      @tree     = node
      @commands = self.class.commands
      instance_eval(&block) if block_given?
      IceNine.deep_freeze(self)
    end

    private # DSL commands

    def method_missing(name, *args, &block)
      node  = @commands[name, *args, &block]
      @tree = tree << (node.is_a?(Branch) ? update(node, &block) : node)
    end

    def respond_to_missing?(*)
      true
    end

    def update(node, &block)
      self.class.update(node, &block)
    end

  end # class Builder

end # class AbstractMapper
