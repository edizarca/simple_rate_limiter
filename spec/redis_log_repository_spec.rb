require 'repositories/redis_record_repository'
RSpec.describe RateLimiter do
  it 'successfully connects' do
    mock_redis = double('redis')
    random = SecureRandom.base64(10)
    expect(mock_redis).to receive(:set).with('test', random).and_return('OK')
    expect(mock_redis).to receive(:get).with('test').and_return(random)
    RateLimiter::Repositories::RedisRecordRepository.build(mock_redis, random)
  end

  it 'raises exception on unsuccessful connects' do
    mock_redis = double('redis')
    random = SecureRandom.method(:base64)
    expect(mock_redis).to receive(:set).with('test', random)
    expect(mock_redis).to receive(:get).with('test').and_return('asdf')
    expect { RateLimiter::Repositories::RedisRecordRepository.build(mock_redis, random) }.to raise_error(RateLimiter::Application::Exceptions::RedisConnectionException)
  end

  it 'adds record' do
    mock_redis = double('redis')
    random = SecureRandom.base64(10)
    time = Time.now
    expect(mock_redis).to receive(:set).with('test', random).and_return('OK')
    expect(mock_redis).to receive(:get).with('test').and_return(random)
    expect(mock_redis).to receive(:lpush).with('test_identifier', time.to_i.to_s)
    rate_limiter = RateLimiter::Repositories::RedisRecordRepository.build(mock_redis, random)
    rate_limiter.add('test_identifier', time)
  end

  it 'gets records by name' do
    mock_redis = double('redis')
    random = SecureRandom.base64(10)
    amount = 3
    expect(mock_redis).to receive(:set).with('test', random).and_return('OK')
    expect(mock_redis).to receive(:get).with('test').and_return(random)
    expect(mock_redis).to receive(:lrange).with('test_identifier', 0, amount - 1)
    rate_limiter = RateLimiter::Repositories::RedisRecordRepository.build(mock_redis, random)
    rate_limiter.get_by_name('test_identifier', 3)
  end

  it 'trims records by name' do
    mock_redis = double('redis')
    random = SecureRandom.base64(10)
    amount = 3
    expect(mock_redis).to receive(:set).with('test', random).and_return('OK')
    expect(mock_redis).to receive(:get).with('test').and_return(random)
    expect(mock_redis).to receive(:ltrim).with('test_identifier', 0, amount - 1)
    rate_limiter = RateLimiter::Repositories::RedisRecordRepository.build(mock_redis, random)
    rate_limiter.trim_by_name('test_identifier', 3)
  end

  it 'removes last record by name' do
    mock_redis = double('redis')
    random = SecureRandom.base64(10)

    expect(mock_redis).to receive(:set).with('test', random).and_return('OK')
    expect(mock_redis).to receive(:get).with('test').and_return(random)
    expect(mock_redis).to receive(:lpop).with('identifier')
    rate_limiter = RateLimiter::Repositories::RedisRecordRepository.build(mock_redis, random)
    rate_limiter.remove_last_by_name('identifier')
  end
end