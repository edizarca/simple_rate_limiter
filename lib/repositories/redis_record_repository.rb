require 'redis'
require 'application/exceptions/redis_connection_error'
require 'securerandom'

module SimpleRateLimiter
  module Repositories
    class RedisRecordRepository
      def initialize(redis, random)
        @redis = redis
        @random = random
      end

      def validate_redis_connection
        test_hash = @random
        result = @redis.set('test', test_hash)
        received = @redis.get('test')
        unless result == 'OK' && received == test_hash
          raise SimpleRateLimiter::Application::Exceptions::RedisConnectionException, 'redis connection unsuccessful, make sure redis is installed and configuration variables are set'
        end
      end

      def self.build(redis, random_value = SecureRandom.base64(10))
        instance = new(redis, random_value)
        instance.validate_redis_connection
        instance
      end

      def add(record_name, time = Time.now)
        @redis.lpush(record_name, time.to_i.to_s)
      end

      def get_by_name(record_name, record_amount = 0)
        @redis.lrange(record_name, 0, record_amount - 1)
      end

      def trim_by_name(record_name, record_amount)
        @redis.ltrim(record_name, 0, record_amount - 1)
      end

      def remove_last_by_name(record_name)
        @redis.lpop(record_name)
      end
    end
  end
end