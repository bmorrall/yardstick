# encoding: utf-8

require 'spec_helper'

describe Yardstick::Parser, '.parse_string' do
  subject(:document_set) { described_class.parse_string(string) }

  let(:string)        { double('string', :to_str => 'body')                      }
  let(:method_object) { double(:file => 'foo.rb', :line => 4, :docstring => docstring) }
  let(:docstring)     { double('docstring')                                   }

  let(:method_objects) { [method_object] }

  before do
    YARD.should_receive(:parse_string).with('body')
    YARD::Registry.stub(:all).with(:method).and_return(method_objects)
  end

  it { should be_a(Yardstick::DocumentSet) }

  its(:length) { should be(1) }

  context 'first document' do
    subject { document_set.first }

    it { should be_a(Yardstick::Document) }

    its(:docstring) { should eq(docstring) }
  end

  context 'when method one object does not have file information' do
    let(:method_objects) do
      [
        method_object,
        double(:file => nil, :line => nil, :docstring => docstring)
      ]
    end

    it { should be_a(Yardstick::DocumentSet) }
    its(:length) { should be(1) }
  end
end
