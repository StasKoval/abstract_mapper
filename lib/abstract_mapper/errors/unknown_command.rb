# encoding: utf-8

class AbstractMapper

  # The collection of gem-specific errors
  #
  module Errors

    # An exception to be raised when unknown DSL methods is used
    #
    # @api public
    #
    class UnknownCommand < NameError

      include Immutability

      # @private
      def initialize(name)
        super "'#{name}' is not a registered DSL command"
      end

    end # class UnknownCommand

  end # module Errors

end # class AbstractMapper
