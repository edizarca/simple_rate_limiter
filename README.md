# SimpleRateLimiter
[![Build Status](https://travis-ci.org/edizarca/simple_rate_limiter.svg?branch=main)](https://travis-ci.org/edizarca/simple_rate_limiter)

Welcome to my first gem! This is a simple rate limiting gem. 

Simple Rate Limiter can limit the usage of a resource by an actor according to parameters provided. 
If an actor exceeds the pre-determined limit the limiter returns true.
On repeated violations, the punishment is increased incrementally according to the punishment factor parameter.
If an actor doesn't violate the resource limit for the same time period of the limitation after it expires, the punishment level is decreased for the actor.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_rate_limiter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install simple_rate_limiter

## Usage

```ruby
redis = Redis.new
redis_record_repository = SimpleRateLimiter::Repositories::RedisRecordRepository.build(redis)
rate_limiter = SimpleRateLimiter::Service.new(redis_record_repository)

limited = rate_limiter.check('create_user', 'unique_user_identifier', 3, 30, 2) # returns true if limited
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/edizarca/simple_rate_limiter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rate_limiter/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the                    GNU GENERAL PUBLIC LICENSE
                                                                                 Version 3, 29 June 2007

## Code of Conduct

Everyone interacting in the RateLimiter project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rate_limiter/blob/master/CODE_OF_CONDUCT.md).
