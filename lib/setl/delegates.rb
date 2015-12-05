require_relative 'errors'

module Setl
  class Delegator
    def initialize(item, error_handler)
      @item = item
      @error_handler = error_handler
    end

    private

    attr_reader :item, :error_handler
  end

  class Source < Delegator
    def each(&block)
      item.each(&block)
    rescue StandardError => e
      # Allow our errors to go through
      if e.is_a? ETLError
        raise e
      else
        error_handler.(SourceError.new("Failed to read from source", e))
      end
    end
  end

  class Transform < Delegator
    def call(row, &block)
      item.call(row, &block)
    rescue StandardError => e
      error_handler.(ProcessingError.new(row, "Failed to process #{row}", e))
    end
  end

  class Destination < Delegator
    def call(row, &block)
      item.call(row, &block)
    rescue StandardError => e
      error_handler.(DestinationError.new(row, "Failed to send #{row}", e))
    end
  end
end
