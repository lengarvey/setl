require 'spec_helper'
require 'setl/controller'

module Setl
  RSpec.describe 'controller' do
    let(:controller) { Controller.new(transform1, transform2) }
    let(:transform1) { double('Transform1', call: 'output') }
    let(:transform2) { double('Transform2', call: 'final result') }
    let(:row) { double('Row') }

    describe 'processing a row of data' do
      it 'creates a pipeline of transforms' do
        expect(transform1).to receive(:call).with(row)
        expect(transform2).to receive(:call).with('output')

        controller.call(row)
      end

      it 'returns the result of all the transformations' do
        expect(controller.call(row)).to eq 'final result'
      end
    end
  end
end
