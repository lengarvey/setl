require 'spec_helper'
require 'setl'

module Setl
  RSpec.describe 'etl' do
    let(:etl) { ETL.new(source, destination) }

    describe 'processing a row' do
      let(:row) { 'hello' }
      let(:source) { [row] }
      let(:destination) { double('Destination', call: true) }
      let(:processed_data) { double('Processed row') }
      let(:transform) { double('Transform', call: processed_data) }

      before do
        etl.process(transform)
      end

      it 'delegates the processing to the transform' do
        expect(transform).to have_received(:call).with(row)
      end

      it 'sends the processed row to the destination' do
        expect(destination).to have_received(:call).with(processed_data)
      end
    end
  end
end
