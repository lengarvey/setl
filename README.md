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
MySource = [{id: 1, name: 'foo'},{foo: 2, name: 'bar'}]
MyDestination = lambda {|d| puts d.inspect }

MyTransform = lambda do |d|
  # In the transform `d` is a duplicated version of the row.
  # So mutating methods like `upcase!` do not operate on the
  # actual source row.
  d[:name].upcase!
  d
end

Setl::ETL.new(MySource, MyDestination).process(MyTransform)
  #=> {id: 1, name: 'FOO'}
  #=> {id: 2, name: 'BAR'}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/setl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
