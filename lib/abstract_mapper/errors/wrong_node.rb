# encoding: utf-8

class AbstractMapper

  module Errors

    # An exception to be raised when wrong node is registered as a DSL command
    #
    # @api public
    #
    class WrongNode < TypeError

      # @private
      def initialize(node)
        super "#{node} is not a subclass of AbstractMapper::Node"
        freeze
      end

    end # class WrongNode

  end # module Errors

end # class AbstractMapper
