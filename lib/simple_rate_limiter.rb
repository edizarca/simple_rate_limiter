require 'repositories/violation_repository'
require 'domain/limiter'

module SimpleRateLimiter
  class Error < StandardError; end

  class Service
    include Domain

    def initialize(record_repository)
      @record_repository = record_repository
      @violation_repository = SimpleRateLimiter::Repositories::ViolationRepository.new(record_repository)
    end

    def check(route_name, user_id, rate_limit, limit_period, punishment_factor)
      limiter = Domain::Limiter.new(route_name, user_id, rate_limit, punishment_factor, limit_period)
      identifier = limiter.identifier
      @record_repository.add(identifier)
      @record_repository.trim_by_name(identifier, rate_limit)

      violation_records = @violation_repository.get_all(identifier)

      return true if limiter.was_violated?(violation_records)

      @violation_repository.remove_last(identifier) if limiter.violation_expired?(violation_records)

      records = @record_repository.get_by_name(identifier, rate_limit)

      if limiter.rate_violated?(records)
        @violation_repository.add(identifier)
        return true
      end

      false
    end
  end
end
