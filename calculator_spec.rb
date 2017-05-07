require 'rspec/autorun'
require_relative 'calculator'

describe 'calculator' do
  calculator = Calculator.new
  it 'handles nil' do
    expect(calculator.evaluate(nil)).to eq(nil)
  end

  it 'handles basic addition' do
    expect(calculator.evaluate('1 + 3')).to eq(4)
  end

  it 'handles basic subtraction' do
    expect(calculator.evaluate('4 - 2')).to eq(2)
  end

  it 'handles complex addition' do
    expect(calculator.evaluate('1 + 2 + 3')).to eq(6)
  end

  it 'handles complex subtraction' do
    expect(calculator.evaluate('7 - 2 - 3')).to eq(2)
  end

  it 'handles floats' do
    expect(calculator.evaluate('5.3 + 4.7')).to eq(10)
  end

  it 'handles division' do
    expect(calculator.evaluate('10/2')).to eq(5)
  end

  it 'handles multiplication' do
    expect(calculator.evaluate('10 * 2')).to eq(20)
  end
  #
  it 'handles mixed operations' do
    expect(calculator.evaluate('2 + 2 / 4')).to eq(2.5)
  end

  it 'handles parentheses' do
    expect(calculator.evaluate('2 * (10 - 2)')).to eq(16)
  end

  it 'checks for mismatched parentheses' do
    expect(calculator.evaluate('2 * (10 - 2))')).to eq(nil)
  end

  it 'handles nested parentheses' do
    expect(calculator.evaluate( '2 * (10 - (2 *3))')).to eq(8)
  end

  it 'handles exponents' do
    expect(calculator.evaluate('2 ^ 4')).to eq(16)
  end

  it 'deletes non allowed characters' do
    expect(calculator.evaluate('5 + 3;')).to eq(8)
  end

  it 'handles double negation' do
    expect(calculator.evaluate('5 -- 2')).to eq(7)
  end
end
