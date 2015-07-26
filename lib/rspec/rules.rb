# encoding: utf-8

# ==============================================================================
# Examples for testing rules
# ==============================================================================

shared_context :rule do

  def nodes
    defined?(input) ? [input].flatten : []
  end

  def optimized
    defined?(output) ? [output].flatten : []
  end

  let(:rule) { described_class }

  subject { rule.new(*nodes).call }

end # shared context

shared_examples :skipping_nodes do

  include_context :rule

  it do
    is_expected.to eql(nodes), <<-REPORT.gsub(/.+\|/, "")
      |
      |#{rule}
      |
      |Input: #{nodes.inspect}
      |
      |Output:
      |  expected: #{nodes.inspect}
      |       got: #{subject}
    REPORT
  end

end # shared examples

shared_examples :optimizing_nodes do

  include_context :rule

  it do
    is_expected.to eql(optimized), <<-REPORT.gsub(/.+\|/, "")
      |
      |#{rule}
      |
      |Input: #{nodes.inspect}
      |
      |Output:
      |  expected: #{optimized.inspect}
      |       got: #{subject}
    REPORT
  end

end # shared examples
