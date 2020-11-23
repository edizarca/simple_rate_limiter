module RateLimiter
  module Domain
    class RateLimit
      def initialize(rate_limit, limit_period)
        @rate_limit = rate_limit
        @limit_period = limit_period
      end

      def exceeded?(records, time = Time.now.to_i)

        if records.length >= @rate_limit
          time_elapsed = time - records.last.to_i
          return true if time_elapsed < @limit_period
        end

        false
      end

    end
  end
end
