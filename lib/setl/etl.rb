module Setl
  class ETL
    def initialize(source, destination, stop_on_errors: false, error_handler: nil)
      @source = source
      @destination = destination
      @stop_on_errors = stop_on_errors
      @error_handler = error_handler || DefaultHandler.new(stop_on_errors)
    end

    def process(transform)
      source.each do |row|
        @last_row = row

        begin
          destination.(transform.(row))
        rescue StandardError => e
          error_handler.(row, e)
        end
      end
    end

    attr_reader :last_row

    private

    attr_reader :source, :destination, :stop_on_errors, :error_handler
  end

  class ProcessingError < StandardError
  end

  class DefaultHandler
    def initialize(reraise)
      @reraise = reraise
    end

    def call(row, exception)
      raise ProcessingError, "Failed to process #{row}" if reraise?
    end

    private

    def reraise?
      @reraise
    end
  end
end
