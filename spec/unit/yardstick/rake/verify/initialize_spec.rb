# encoding: utf-8

require 'spec_helper'
require 'yardstick/rake/verify'

describe Yardstick::Rake::Verify, '#initialize' do
  context 'with custom arguments' do
    subject(:task) { described_class.new(:verify, options) }

    let(:config)  { Yardstick::Config.new(:threshold => 90) }
    let(:options) { double('options')                    }

    before do
      Yardstick::Config.stub(:coerce).with(options) { config }
    end

    context 'when valid options' do
      it { should be_a(described_class) }

      it 'creates rake task with given name' do
        subject
        expect(Rake::Task['verify']).to be_kind_of(Rake::Task)
      end

      it 'calls verify_measurements when rake task is executed' do
        subject
        task.should_receive(:verify_measurements)
        Rake::Task['verify'].execute
      end

      it 'should include the threshold in the task name' do
        task
        expect(Rake.application.last_description)
          .to eql('Verify that yardstick coverage is at least 90%')
      end
    end

    context 'when threshold is not specified' do
      before { config.threshold = nil }

      it 'raises error' do
        expect { task }.to raise_error(RuntimeError, 'threshold must be set')
      end
    end
  end

  context 'when with default arguments' do
    subject { described_class.new }

    it { should be_a(described_class) }

    it 'assigns verify_measurements as the name' do
      subject
      expect(Rake::Task['verify_measurements']).to be_kind_of(Rake::Task)
    end
  end

  context 'when block provided' do
    subject(:task) do
      described_class.new do |config|
        @yield = config
      end
    end

    it { should be_a(described_class) }

    it 'should yield to Config' do
      task
      expect(@yield).to be_instance_of(Yardstick::Config)
    end
  end
end
