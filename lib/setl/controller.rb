module Setl
  class Controller
    def initialize(*pipeline)
      @pipeline = pipeline
    end

    def call(row)
      pipeline.each { |t| row = t.(row) }
      row
    end

    private

    attr_reader :pipeline
  end
end
