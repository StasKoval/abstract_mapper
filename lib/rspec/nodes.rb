# encoding: utf-8

# ==============================================================================
# Examples for testing nodes
# ==============================================================================

shared_context :node do

  def node
    attrs__ = defined?(attributes) ? attributes : []
    block__ = defined?(block) ? block : nil
    described_class.new(*attrs__, &block__)
  end

end # shared context

shared_examples :creating_immutable_node do

  include_context :node

  subject { node }

  it { is_expected.to be_kind_of AbstractMapper::Node }
  it { is_expected.to be_frozen, "expected #{subject.inspect} to be immutable" }

end # shared examples

shared_examples :creating_immutable_branch do

  include_context :node

  subject { node }

  it { is_expected.to be_kind_of AbstractMapper::Branch }
  it { is_expected.to be_frozen, "expected #{subject.inspect} to be immutable" }

end # shared examples

shared_examples :mapping_immutable_input do

  include_context :node

  let(:immutable_input) do
    begin
      input.dup.freeze
    rescue TypeError # in case input is a singleton that cannot be duplicated
      input
    end
  end

  subject(:transproc) { node.transproc }

  it "creates a composable transproc" do
    expect(transproc).to be_kind_of Transproc::Function
  end

  it "maps the input" do
    expect(transproc[immutable_input])
      .to eql(output), <<-REPORT.gsub(/.+\|/, "")
        |
        |#{node}
        |
        |Input: #{input}
        |
        |Output:
        |  expected: #{output}
        |       got: #{transproc[immutable_input]}
      REPORT
  end

end # shared examples
