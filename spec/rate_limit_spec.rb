RSpec.describe SimpleRateLimiter::Domain::RateLimit do
  before(:each) do
    rate_limit = 3
    limit_period = 30
    @rate_limit = SimpleRateLimiter::Domain::RateLimit.new(rate_limit, limit_period)
  end

  it 'rate limit is not exceeded with 1 record' do
    time_now = Time.now.to_i
    record = Time.now.to_i - 5
    records = [record]
    expect(@rate_limit.exceeded?(records, time_now)).to eq(false)
  end
  it 'rate limit is not exceeded with 3 records' do
    time_now = Time.now.to_i
    record = Time.now.to_i - 5
    record_two = Time.now.to_i - 20
    record_three = Time.now.to_i - 36
    records = [record, record_two, record_three]
    expect(@rate_limit.exceeded?(records, time_now)).to eq(false)
  end

  it 'rate limit is exceeded with 3 records' do
    time_now = Time.now.to_i
    record = Time.now.to_i - 5
    record_two = Time.now.to_i - 20
    record_three = Time.now.to_i - 29
    records = [record, record_two, record_three]
    expect(@rate_limit.exceeded?(records, time_now)).to eq(true)
  end
end