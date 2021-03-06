# encoding: utf-8

require 'spec_helper'

describe Yardstick::Document, '#api?' do
  subject { described_class.new(docstring).api?(types) }

  let(:docstring) { double('docstring') }

  before do
    docstring.stub(:tag).with('api') { double(:text => 'private') }
  end

  context 'when tag is equal' do
    let(:types) { ['private'] }

    it { should be(true) }
  end

  context 'when tag is not equal' do
    let(:types) { ['public'] }

    it { should be(false) }
  end
end
