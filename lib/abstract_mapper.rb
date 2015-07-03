# encoding: utf-8

require "transproc"

require_relative "abstract_mapper/functions"

require_relative "abstract_mapper/errors/unknown_command"
require_relative "abstract_mapper/errors/wrong_node"
require_relative "abstract_mapper/errors/wrong_rule"

require_relative "abstract_mapper/node"
require_relative "abstract_mapper/branch"
require_relative "abstract_mapper/commands"
require_relative "abstract_mapper/builder"

require_relative "abstract_mapper/rule"
require_relative "abstract_mapper/sole_rule"
require_relative "abstract_mapper/pair_rule"
require_relative "abstract_mapper/rules"
require_relative "abstract_mapper/optimizer"

require_relative "abstract_mapper/settings"
require_relative "abstract_mapper/dsl"

# The configurable base class for mappers
#
# The mapper DSL is configured by assigning it a specific settings:
#
#   class BaseMapper < AbstractMapper::Mapper
#     configure do
#       command :list, List     # domain-specific command
#       command :rename, Rename # domain-specific command
#
#       rule MergeLists         # domain-specific rule
#     end
#   end
#
# Then a configured mapper can use a corresponding DSL commands
#
#   class ConcreteMapper < BaseMapper
#     list do
#       rename :foo, to: :bar
#     end
#   end
#
# @api public
#
class AbstractMapper

  extend DSL # configurable DSL container

  # @!attribute [r] tree
  #
  # @return [AbstractMapper::Branch] AST
  #
  attr_reader :tree

  # @!scope class
  # @!method new
  # Creates a mapper instance with the optimized AST
  #
  # @return [AbstractMapper::Mapper]

  # @private
  def initialize
    @tree = self.class.finalize
    @transproc = @tree.transproc
    freeze
  end

  # Maps the input data to some output using the transformation,
  # described by the optimized [#tree]
  #
  # @param [Object] input
  #
  # @return [Object]
  #
  def call(input)
    @transproc.call(input)
  end

end # class AbstractMapper
