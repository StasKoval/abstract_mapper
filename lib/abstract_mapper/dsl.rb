# encoding: utf-8

class AbstractMapper

  # Provides features to configure mappers
  #
  # @api private
  #
  module DSL

    # @private
    def inherited(klass)
      klass.instance_variable_set :@settings, settings
    end

    # @!attribute [r] settings
    #
    # @return [AbstractMapper::Settings]
    #   The configurable container of domain-specific settings
    #   (DSL commands and optimization rules along with corresponding
    #   AST builder and optimizer).
    #
    attr_reader :settings

    # Configures domain-specific settings
    #
    # @param [Proc] block The block where rules and commands to be registered
    #
    # @return [self] itself
    #
    # @yield a block
    #
    def configure(&block)
      @settings = Settings.new(&block)
      self
    end

    # Returns the optimized AST
    #
    # @return [AbstractMapper::Branch]
    #
    def finalize
      settings.optimizer.update(tree)
    end

    private # DSL commands

    def tree
      @tree ||= Branch.new
    end

    def respond_to_missing?(*)
      true
    end

    def method_missing(name, *args, &block)
      @tree = settings.builder.update(tree) { public_send(name, *args, &block) }
    end

  end # module DSL

end # class AbstractMapper
