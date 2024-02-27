# Minitest::DefinedMock
`Minitest::DefinedMock` provides a way to safely build mocks for object dependencies, when you're unable to manage your dependencies in a preferable way. It will not only implement normal `Minitest::Mock` behavior but also perform an extra step to _verify_ that the method you expect does in fact exist on the object dependency and that the correct arguments are passed in. This gem just wraps `Minitest::Mock#expect` and `Minitest::Mock#verify` and enhances their behavior with these extra cases.

An issue may arise when you're testing with mocks and an underlying method has changed on a depdenent object which can sometimes create a situation where your tests pass, but your functionality doesn't work. `Minitest::DefinedMock` helps to prevent this issue.

## Installation

```ruby
# Install via Gemfile
gem 'minitest'
gem 'minitest-defined_mock'

# $ bundle install

# ...or install globally
gem install 'minitest-defined_mock'
```

## Usage
> Depending on the design of your system and your projects goals the need for this library may indicate a code smell. This library is intended to be a "band-aid" to provide a tiny bit more safety to the code that exists in real world projects.

Use `Minitest::DefinedMock` just as you would use `Minitest::Mock` with the addition of an argument that is the object you expect to have implemented that method.

``` ruby
# Models
User = Struct.new(:id, :email) # Example user

class Recording
  def initialize(source_id: nil, source_contact_method: nil)
    @source_id = source_id
    @source_contact_method = source_contact_method
  end

  def record_action_by(user:)
    @source_id = user.id
    @source_contact_method = user.email
  end
end

# Test
mock = Minitest::DefinedMock.new(User)
mock.expect(:id, 1, [])
mock.expect(:email, "test@test.com", [])

@recording = Recording.new.record_action_by(user: mock)

assert_mock mock
assert_equal 1, @recording.source_id
assert_equal "test@test.com", @recording.source_contact_method
```

The enhancments `DefinedMock` provides are in the `mock.verify` method (which `assert_mock` calls under the hood.) This method will take the Constant you provided as an argument and verify the the expected method and it's arguments (ordered & keyword) match what's implemented by the caller. If the method doesn't exist, is missing an argument, or is called with an incorrect keyword argument, `mock.verify` will raise a `Minitest::DefinedMock::ExpectationError` with a message indicating what went wrong.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/juliusdelta/minitest-defined_mock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/juliusdelta/minitest-defined_mock/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Minitest::DefinedMock project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/juliusdelta/minitest-defined_mock/blob/master/CODE_OF_CONDUCT.md).
