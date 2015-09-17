# encoding: utf-8

class AbstractMapper

  # The namespace for the gem-specific exceptions
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  module Errors

    require_relative "errors/unknown_command"
    require_relative "errors/wrong_node"
    require_relative "errors/wrong_rule"

  end # module Errors

end # class AbstractMapper
