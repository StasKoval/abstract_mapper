# encoding: utf-8

describe AbstractMapper::Errors::UnknownCommand do

  subject(:error) { described_class.new :foo }

  describe ".new" do
    it { is_expected.to be_kind_of NameError }
    it { is_expected.to be_frozen }
  end # describe .new

  describe "#message" do
    subject { error.message }

    it { is_expected.to eql "'foo' is not a registered DSL command" }
  end # describe #message

end # describe AbstractMapper::Errors::UnknownCommand
