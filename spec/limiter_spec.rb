RSpec.describe RateLimiter::Domain::Limiter do
  before(:each) do
    route_name = 'test_name'
    user_id = 'test_id'
    rate_limit = 3
    punishment_factor = 2
    limit_period = 30
    @limiter = RateLimiter::Domain::Limiter.new(route_name, user_id, rate_limit, punishment_factor, limit_period)
  end

  it 'assigns id by adding route_name and user_id together'do
    expect(@limiter.identifier).to eq('test_name-test_id')
  end

  it 'was violated' do
    violation = Time.now.to_i - 10
    violation_two = Time.now.to_i - 20
    violation_three = Time.now.to_i - 21
    violations = [violation, violation_two, violation_three]
    expect(@limiter.was_violated?(violations)).to eq(true)
  end
  it 'was not violated' do
    violation = Time.now.to_i - 60
    violation_two = Time.now.to_i - 90
    violation_three = Time.now.to_i - 121
    violations = [violation, violation_two, violation_three]
    expect(@limiter.was_violated?(violations)).to eq(false)
  end

  it 'violation expired' do
    violation_record = Time.now.to_i - 61
    violation_records = [violation_record]
    expect(@limiter.violation_expired?(violation_records)).to eq(true)
  end

  it 'violation was not expired' do
    violation_record = Time.now.to_i - 59
    violation_records = [violation_record]
    expect(@limiter.violation_expired?(violation_records)).to eq(false)
  end

  it 'rate violated' do
    violation_record = Time.now.to_i - 59
    violation_records = [violation_record]
    expect(@limiter.violation_expired?(violation_records)).to eq(false)
  end

  it 'rate was violated' do
    record = Time.now.to_i - 10
    record_two = Time.now.to_i - 20
    record_three = Time.now.to_i - 19
    records = [record, record_two, record_three]
    expect(@limiter.rate_violated?(records)).to eq(true)
  end

  it 'rate was not violated' do
    record = Time.now.to_i - 10
    records = [record]
    expect(@limiter.rate_violated?(records)).to eq(false)
  end

  it 'rate was not violated' do
    record = Time.now.to_i - 10
    record_two = Time.now.to_i - 20
    record_three = Time.now.to_i - 65
    records = [record, record_two, record_three]
    expect(@limiter.rate_violated?(records)).to eq(false)
  end
end
