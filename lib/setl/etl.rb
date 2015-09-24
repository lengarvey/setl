require_relative 'delegates'

module Setl
  class ETL
    def initialize(source, destination, transform, stop_on_errors: false, error_handler: nil)
      @stop_on_errors = stop_on_errors
      @error_handler = error_handler || DefaultHandler.new(stop_on_errors)

      @source = Source.new(source, @error_handler)
      @destination = Destination.new(destination, @error_handler)
      @transform = Transform.new(transform, @error_handler)
    end

    def process
      source.each do |row|
        @last_row = row

        destination.(transform.(row))
      end
    end

    attr_reader :last_row

    private

    attr_reader :source, :destination, :transform, :stop_on_errors, :error_handler
  end

  class DefaultHandler
    def initialize(reraise)
      @reraise = reraise
    end

    def call(exception)
      raise exception if reraise?
    end

    private

    def reraise?
      @reraise
    end
  end
end
