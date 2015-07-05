# encoding: utf-8

require "transproc/rspec"

describe AbstractMapper::Functions, "#subclass?" do

  let(:klass) { Class.new  }
  let(:modul) { Module.new }

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:subclass?, klass] }

    let(:input)  { Class.new }
    let(:output) { false     }
  end

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:subclass?, klass] }

    let(:input)  { Class.new(Class.new(klass)) }
    let(:output) { true }
  end

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:subclass?, modul] }

    let(:input)  { Class.new }
    let(:output) { false }
  end

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:subclass?, modul] }

    let(:input)  { Class.new.send :include, modul }
    let(:output) { true }
  end

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:subclass?, modul] }

    let(:input)  { Class.new.send :extend, modul }
    let(:output) { false }
  end

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:subclass?, modul] }

    let(:input)  { Module.new }
    let(:output) { false }
  end

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:subclass?, modul] }

    let(:input)  { Module.new.send :include, modul }
    let(:output) { true }
  end

  it_behaves_like :transforming_immutable_data do
    let(:arguments) { [:subclass?, modul] }

    let(:input)  { Module.new.send :extend, modul }
    let(:output) { false }
  end

end # describe AbstractMapper::Functions#subclass?
