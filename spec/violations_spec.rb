require 'domain/violations'

RSpec.describe SimpleRateLimiter::Domain::Violations do

  before(:each) do
    punishment_factor = 2
    limit_period = 30
    @violations = SimpleRateLimiter::Domain::Violations.new(punishment_factor, limit_period)
  end

  it 'violations exists' do
    violation_records = ['true']
    @violations.exist?(violation_records)
    expect(@violations.exist?(violation_records)).to eq(true)
  end

  it 'violations doesnt exist' do
    violation_records = []
    expect(@violations.exist?(violation_records)).to eq(false)
  end

  it 'violations do not apply' do
    time = Time.now.to_i
    violation = time - 80
    violation_records = [violation]
    expect(@violations.apply?(violation_records,time)).to eq(false)
  end

  it 'violations apply' do
    time = Time.now.to_i
    violation = time - 20
    violation_records = [violation]
    expect(@violations.apply?(violation_records,time)).to eq(true)
  end

  it 'double violation applies' do
    time = Time.now.to_i
    violation = time - 20
    violation_two = time - 60
    violation_records = [violation_two, violation]
    expect(@violations.apply?(violation_records,time)).to eq(true)
  end

  it 'triple violation applies' do
    time = Time.now.to_i
    violation = time - 20
    violation_two = time - 60
    violation_three = time - 90
    violation_records = [violation, violation_two, violation_three]
    expect(@violations.apply?(violation_records,time)).to eq(true)
  end

  it 'violation does not apply' do
    time = Time.now.to_i
    violation = time - 120
    violation_two = time - 242
    violation_three = time - 243
    violation_records = [violation, violation_two, violation_three]
    expect(@violations.apply?(violation_records, time)).to eq(false)
  end

  it 'violation is not expired' do
    time = Time.now.to_i
    violation = time - 20
    violation_records = [violation]
    expect(@violations.expired?(violation_records, time)).to eq(false)
  end

  it 'violation is expired' do
    time = Time.now.to_i
    violation = time - 31
    violation_records = [violation]
    expect(@violations.expired?(violation_records, time)).to eq(false)
  end

  it 'violation is expired' do
    time = Time.now.to_i
    violation = time - 61
    violation_records = [violation]
    expect(@violations.expired?(violation_records, time)).to eq(true)
  end

  it 'double violation is not expired' do
    time = Time.now.to_i
    violation = time - 31
    violation_two = time - 119
    violation_records = [violation, violation_two]
    expect(@violations.expired?(violation_records, time)).to eq(false)
  end

  it 'double violation is expired' do
    time = Time.now.to_i
    violation = time - 31
    violation_two = time - 121
    violation_records = [violation, violation_two]
    expect(@violations.expired?(violation_records, time)).to eq(true)
  end

  it 'double violation is expired with custom punishment factor and limit period' do
    time = Time.now.to_i
    violation = time - 46
    violation_two = time - 271
    violation_records = [violation, violation_two]

    punishment_factor = 3
    limit_period = 45
    @violations = SimpleRateLimiter::Domain::Violations.new(punishment_factor, limit_period)

    expect(@violations.expired?(violation_records, time)).to eq(true)

  end

  it 'double violation is not expired with custom punishment factor and limit period' do
    time = Time.now.to_i
    violation = time - 46
    violation_two = time - 269
    violation_records = [violation, violation_two]

    punishment_factor = 3
    limit_period = 45
    @violations = SimpleRateLimiter::Domain::Violations.new(punishment_factor, limit_period)

    expect(@violations.expired?(violation_records, time)).to eq(false)

  end



end