require "setl/version"

module Setl
  class ETL
    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def process(transform)
      source.each do |row|
        destination.(transform.(row))
      end
    end

    private

    attr_reader :source, :destination
  end
end
