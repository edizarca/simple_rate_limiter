module RateLimiter
  module Domain
    class Violations
      def initialize(punishment_factor, limit_period)
        @punishment_factor = punishment_factor
        @limit_period = limit_period
      end

      def exist?(records)
        return true unless records.empty?

        false
      end

      def apply?(violation_records,  time = Time.now.to_i)
        violation_period = get_violation_period(violation_records)
        time_elapsed = get_time_elapsed(violation_records, time)
        return true if time_elapsed < violation_period

        false
      end

      def expired?(violation_records, time = Time.now.to_i)
        time_elapsed = get_time_elapsed(violation_records, time)
        violation_period = get_violation_period(violation_records)
        post_violation_period = violation_period * 2
        return false if time_elapsed < post_violation_period

        true
      end

      def get_violation_period(violation_records)
        (@punishment_factor**(violation_records.length - 1)) * @limit_period
      end

      def get_time_elapsed(violation_records, time)
        time - violation_records.last.to_i
      end
    end
  end
end
