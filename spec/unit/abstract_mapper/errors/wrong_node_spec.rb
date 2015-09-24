# encoding: utf-8

describe AbstractMapper::Errors::WrongNode do

  let(:error) { described_class.new Symbol }

  describe ".new" do
    subject { error }

    it { is_expected.to be_kind_of TypeError }
    it { is_expected.to be_immutable }
  end # describe .new

  describe "#message" do
    subject { error.message }

    it do
      is_expected.to eql "Symbol is not a subclass of AbstractMapper::AST::Node"
    end
  end # describe #message

end # describe AbstractMapper::Errors::WrongNode
