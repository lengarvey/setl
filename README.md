# Setl

A simple framework for writing testable ETL systems. Takes concepts from Kiba but reorganises them to use simple objects, composition and dependency injection. This means your ETL stays simple, reliable and testable.

DSLs are cool, but composable, testable objects are cooler.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'setl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install setl

## Usage

1. Define an object that is responsible for sourcing the data. Must respond to `#each` and `yield` to the provided block.
2. Define your transformations. These are simple objects that will receive one of the things provided by the source object.
3. Provide your transforms to a controller object. Setl provides `Setl::Controller` and you can simply add your transforms into this object. Can actually be any object that responds to `#call`
4. Define a destination object. Must respond to `#call` and sends output of each transformed row of data to a destination.

```ruby
source = [{id: 1, name: 'foo'},{id: 2, name: 'bar'}]
destination = lambda {|d| puts d.inspect }

transform = lambda do |d|
  d[:name].upcase!
  d
end

Setl::ETL.new(source, destination).process(transform)
  #=> {id: 1, name: 'FOO'}
  #=> {id: 2, name: 'BAR'}
```

See the examples folder for some more extensive, and realistic, implementations.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/setl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
