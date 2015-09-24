require 'spec_helper'
require 'setl/etl'

module Setl
  RSpec.describe 'error handling' do
    let(:etl) { ETL.new(source, destination, transform) }
    let(:source) { [1, 2] }
    let(:destination) { double('Destination', call: true) }
    let(:transform) do
      Class.new do
        def self.call(row)
          raise 'nope' if row == 1
        end
      end
    end

    let(:process) { etl.process }

    context 'by default' do
      it 'rescues the error' do
        expect { process }.to_not raise_error
      end

      it 'processes the next row' do
        allow(transform).to receive(:call).with(1)
        expect(transform).to receive(:call).with(2)
        process
      end
    end

    context 'when configured to stop on errors' do
      let(:etl) { ETL.new(source, destination, transform, stop_on_errors: true) }

      it 'stops processing when a processing error occurs' do
        expect { process }.to raise_error(ProcessingError, 'Failed to process 1')
      end

      it 'wraps the original error' do
        begin
          process
        rescue ProcessingError => e
          expect(e.cause).to be_a RuntimeError
        end
      end
    end

    context 'when provided an error handler' do
      let(:handler) do
        Class.new do
          def self.call(exception)
            raise exception
          end
        end
      end

      let(:etl) { ETL.new(source, destination, transform, error_handler: handler) }

      it 'sends a processing error to the handler' do
        expect(handler).to receive(:call).with(an_instance_of(ProcessingError))

        process
      end

      specify 'the error contains the original cause' do
        begin
          process
        rescue ProcessingError => e
          expect(e.cause).to be_a RuntimeError
        end
      end

      context 'when the source raises an exception' do
        let(:handler) { double('ErrorHandler', call: true) }

        let(:source) do
          Class.new do
            def self.each
              raise "nope"
            end
          end
        end

        it 'sends a SourceError to the handler' do
          expect(handler).to receive(:call).with(an_instance_of(SourceError))

          process
        end
      end

      context 'when the destination raises an exception' do
        let(:handler) { double('ErrorHandler', call: true) }
        let(:destination) do
          Class.new do
            def self.call(row)
              raise "lol"
            end
          end
        end

        it 'sends a destination error to the handler' do
          expect(handler).to receive(:call).with(an_instance_of(DestinationError))

          process
        end
      end
    end
  end
end
