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

## Basics

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

## Error Handling

By default Setl will ignore errors and move on to the next "row" of data. This is configurable with by setting `stop_on_errors` to true:

```ruby
Setl::ETL.new(source, destination, stop_on_errors: true).process(transform)
```

If you want to handle errors on your own and perhaps do some sort of logging then simply provide an `error_handler`.

```ruby
error_handler = proc { |row, exception| logger.error "Something failed on #{row.inspect} with #{exception.inspect}" }

Setl::ETL.new(source, destination, error_handler: error_handler).process(transform)
```

If you provide an error handler, then `stop_on_errors` is ignored. You're responsible for handling your own errors. The error handler is simply an object that responds to `call` and accepts the failing row of data and the exception that was raised. You can retrieve the original exception by looking at `exception.cause`.

## Tips and Todo

* Mixes well with [Transproc](https://github.com/solnic/transproc).
* Check out [Kiba](https://github.com/thbar/kiba) which is a more mature ETL library for Ruby.
* Need to investigate how to dispatch rows to a job runner like Sidekiq or SQS.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/setl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
