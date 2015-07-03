# encoding: utf-8

require "transproc"

require_relative "abstract_mapper/functions"

require_relative "abstract_mapper/errors/unknown_command"
require_relative "abstract_mapper/errors/wrong_node"

require_relative "abstract_mapper/node"
require_relative "abstract_mapper/branch"
require_relative "abstract_mapper/commands"
require_relative "abstract_mapper/builder"

require_relative "abstract_mapper/rule"
require_relative "abstract_mapper/sole_rule"
require_relative "abstract_mapper/pair_rule"
require_relative "abstract_mapper/rules"
require_relative "abstract_mapper/optimizer"

# The configurable base class for mappers
#
class AbstractMapper

end # class AbstractMapper
