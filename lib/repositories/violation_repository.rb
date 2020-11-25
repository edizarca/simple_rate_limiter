
module SimpleRateLimiter
  module Repositories
    class ViolationRepository
      def initialize(record_repository)
        @record_repository = record_repository
      end

      def get_all(identifier)
        @record_repository.get_by_name(identifier + '.violation')
      end

      def remove_last(identifier)
        @record_repository.remove_last_by_name(identifier + '.violation')
      end

      def add(identifier)
        @record_repository.add(identifier + '.violation')
      end
    end
  end
end
