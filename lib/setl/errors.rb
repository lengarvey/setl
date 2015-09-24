module Setl
  class ETLError < StandardError
  end

  class ProcessingError < ETLError
    def initialize(row, message=nil)
      super message
      @row = row
    end

    attr_reader :row
  end

  class SourceError < ETLError
  end

  class DestinationError < ETLError
    def initialize(row, message=nil)
      super message
      @row = row
    end

    attr_reader :row
  end
end
