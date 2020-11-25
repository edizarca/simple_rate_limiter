require 'domain/violations'
require 'domain/rate_limit'

module SimpleRateLimiter
  module Domain
    class Limiter
      def initialize(route_name, user_id, rate_limit, punishment_factor, limit_period)
        @identifier = route_name + '-' + user_id
        @punishment_factor = punishment_factor
        @limit_period = limit_period
        @rate_limit = rate_limit
        @violations = Violations.new(@punishment_factor, @limit_period)
        @rate_limit = RateLimit.new(@rate_limit, @limit_period)
      end

      attr_reader :identifier

      def was_violated?(violation_records)
        if @violations.exist?(violation_records)
          if @violations.apply?(violation_records)
            return true
          end
        end

        false
      end

      def violation_expired?(violation_records)
        @violations.expired?(violation_records)
      end

      def rate_violated?(records)
        @rate_limit.exceeded?(records)
      end
    end
  end
end
