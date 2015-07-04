# encoding: utf-8

# ==============================================================================
# Examples for testing transproc functions
# ==============================================================================

shared_examples :transforming_immutable_data do

  let(:fn) { described_class[*arguments] }

  let(:immutable_input) do
    begin
      input.dup.freeze
    rescue TypeError # in case input is a singleton that cannot be duplicated
      input
    end
  end

  subject { fn[immutable_input] }

  it do
    is_expected.to eql(output), <<-REPORT.gsub(/.+\|/, "")
      |
      |fn = #{described_class}[{arguments}]
      |
      |fn#{Array[*input]}
      |
      |  expected: #{output}
      |       got: #{subject}
    REPORT
  end

end # shared examples
