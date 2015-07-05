# encoding: utf-8

# ==============================================================================
# Examples for testing DSL registry
# ==============================================================================

shared_examples :defining_rule do

  subject { described_class.settings.rules.registry }
  it do
    is_expected.to include(rule), <<-REPORT.gsub(/.+\|/, "")
      |
      |#{described_class} optimization rules
      |
      |expected to include #{rule.inspect}
      |     got rules:
      |#{subject.map { |rule| "#{" " * 9}- #{rule.inspect}" }.join("\n")}
    REPORT
  end

end # shared examples

shared_examples :defining_command do

  subject { described_class.settings.commands.registry }
  it "registers the command" do
    expect(subject[name]).to eql(node), <<-REPORT.gsub(/.+\|/, "")
      |
      |#{described_class} DSL commands
      |
      |expected to include '#{name}' that adds #{node.inspect}
      |     got commands:
      |#{subject
        .map { |name, node| "#{" " * 9}- #{name}: #{node.inspect}" }
        .sort
        .join("\n")}
    REPORT
  end

end # shared examples
