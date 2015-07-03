# encoding: utf-8

require "transproc"

require_relative "abstract_mapper/functions"

require_relative "abstract_mapper/errors/unknown_command"

require_relative "abstract_mapper/node"
require_relative "abstract_mapper/branch"
require_relative "abstract_mapper/commands"
require_relative "abstract_mapper/builder"

require_relative "abstract_mapper/rule"
require_relative "abstract_mapper/sole_rule"

# The configurable base class for mappers
#
class AbstractMapper

end # class AbstractMapper
