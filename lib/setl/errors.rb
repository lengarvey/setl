module Setl
  class ETLError < StandardError
  end

  class ProcessingError < ETLError
    def initialize(row, message=nil, cause=$!)
      super message
      @row = row
      @cause = cause
    end

    attr_reader :row, :cause
  end

  class SourceError < ETLError
    def initialize(message=nil, cause=$!)
      super(message)
      @cause = cause
    end

    attr_reader :cause
  end

  class DestinationError < ETLError
    def initialize(row, message=nil, cause=$!)
      super message
      @row = row
      @cause = cause
    end

    attr_reader :row, :cause
  end
end
