# encoding: utf-8

class AbstractMapper

  # The namespace for nodes of the abstract syntax tree
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  module AST

    require_relative "ast/node"
    require_relative "ast/branch"

  end # module AST

end # class AbstractMapper
