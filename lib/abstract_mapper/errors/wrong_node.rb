# encoding: utf-8

class AbstractMapper

  module Errors

    # An exception to be raised when wrong node is registered as a DSL command
    #
    # @api public
    #
    class WrongNode < TypeError

      include Immutability

      # @private
      def initialize(node)
        super "#{node} is not a subclass of AbstractMapper::AST::Node"
      end

    end # class WrongNode

  end # module Errors

end # class AbstractMapper
