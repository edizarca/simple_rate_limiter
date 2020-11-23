require 'active_support'
require 'rate_limiter'

RSpec.describe RateLimiter do
  it "has a version number" do
    expect(RateLimiter::VERSION).not_to be nil
  end

  before(:each) do
    @mock_record_repository = double('record_repository')
    @rate_limiter = RateLimiter::Service.new(@mock_record_repository)
  end

  it 'limiter was violated' do
    route_name = 'route_name'
    user_id = 'user_id'
    punishment_factor = 2
    rate_limit = 3
    limit_period = 30

    violation_records = [Time.now.to_i - 20]
    expect(check(route_name, user_id, rate_limit, limit_period, punishment_factor, violation_records)).to eq(true)
  end

  it 'limiter was not violated but expired violation is removed' do
    route_name = 'route_name'
    user_id = 'user_id'
    punishment_factor = 2
    rate_limit = 3
    limit_period = 30
    identifier = route_name + '-' + user_id
    violation_records = [Time.now.to_i - 61]
    records = []
    expect(@mock_record_repository).to receive(:remove_last_by_name).with(identifier + '.violation')
    expect(@mock_record_repository).to receive(:get_by_name).with(identifier, rate_limit).and_return(records)
    expect(check(route_name, user_id, rate_limit, limit_period, punishment_factor, violation_records)).to eq(false)
  end

  it 'limiter was violated but expired violation is removed' do
    route_name = 'route_name'
    user_id = 'user_id'
    punishment_factor = 2
    rate_limit = 3
    limit_period = 30
    identifier = route_name + '-' + user_id
    violation_records = [Time.now.to_i - 61]
    records = [Time.now.to_i - 10, Time.now.to_i - 20, Time.now.to_i - 21]
    expect(@mock_record_repository).to receive(:remove_last_by_name).with(identifier + '.violation')
    expect(@mock_record_repository).to receive(:get_by_name).with(identifier, rate_limit).and_return(records)
    expect(@mock_record_repository).to receive(:add).with(identifier + '.violation')
    expect(check(route_name, user_id, rate_limit, limit_period, punishment_factor, violation_records)).to eq(true)
  end

  it 'limiter was violated but there is no expired violation to remove' do
    route_name = 'route_name'
    user_id = 'user_id'
    punishment_factor = 2
    rate_limit = 3
    limit_period = 30
    identifier = route_name + '-' + user_id
    violation_records = [Time.now.to_i - 32]
    records = [Time.now.to_i - 10, Time.now.to_i - 20, Time.now.to_i - 21]
    expect(@mock_record_repository).to receive(:get_by_name).with(identifier, rate_limit).and_return(records)
    expect(@mock_record_repository).to receive(:add).with(identifier + '.violation')
    expect(check(route_name, user_id, rate_limit, limit_period, punishment_factor, violation_records)).to eq(true)
  end

  def check(route_name, user_id, rate_limit, limit_period, punishment_factor, violation_records)
    identifier = route_name + '-' + user_id
    expect(@mock_record_repository).to receive(:add).with(identifier)
    expect(@mock_record_repository).to receive(:trim_by_name).with(identifier, rate_limit)
    expect(@mock_record_repository).to receive(:get_by_name).with(identifier + '.violation').and_return(violation_records)

    @rate_limiter.check(route_name, user_id, rate_limit, limit_period, punishment_factor)
  end


end
