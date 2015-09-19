require 'setl'
require 'json'
require 'transproc'

class Products
  def initialize
    @products = JSON.load(File.open('products.json'))['products']
  end

  attr_reader :products

  def each
    products.each do |product|
      yield product
    end
  end
end

require 'ostruct'

class Product < OpenStruct
end

class ProductTransformations < Setl::Controller
  class Function
    extend Transproc::Registry
    import Transproc::HashTransformations
  end

  class CreateProduct
    def self.call(row)
      Product.new(row)
    end
  end

  TRANSFORMS = [
    Function[:deep_symbolize_keys],
    Function[:accept_keys, [:id, :title, :body_html, :updated_at]],
    Function[:rename_keys, body_html: :body],
    CreateProduct
  ]

  def self.call(row)
    new(*TRANSFORMS).call(row)
  end
end

Destination = proc { |output| puts output.inspect }

Setl::ETL.new(Products.new, Destination).process(ProductTransformations)
