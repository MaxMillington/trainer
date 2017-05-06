require 'pry'

class Calculator
  attr_accessor :value

  def evaluate(input)
    return if input.nil? || input.class != String
    return unless parentheses_match?(input)
    clean_input = remove_spaces_and_non_allowed_characters(input)

    exponent = clean_input.match(/([0-9]*\.?[0-9]*)([\^])(-?[0-9]*\.?[0-9]*)/)
    value = perform_exponent_calc(exponent) if exponent

    multiply_divide = clean_input.match(/([0-9]*\.?[0-9]*)([\*\/])(-?[0-9]*\.?[0-9]*)/)
    value = perform_multiplication_division_calc(multiply_divide) if multiply_divide

    add_subtract = clean_input.match(/(\-?[0-9]*\.?[0-9]*)([\+\-])([0-9]*\.?[0-9]*)/)
    value = perform_addition_subtraction_calc(add_subtract) if add_subtract

    value
  end

  private

  def perform_addition_subtraction_calc(input)
    return input[1].to_f + input[3].to_f if input[2] == '+'
    return input[1].to_f - input[3].to_f if input[2] == '-'
  end

  def perform_multiplication_division_calc(input)
    return input[1].to_f * input[3].to_f if input[2] == '*'
    return input[1].to_f / input[3].to_f if input[2] == '/'
  end

  def perform_exponent_calc(input)
    input[1].to_f ** input[3].to_f if input[2] == '^'
  end

  def remove_spaces_and_non_allowed_characters(input)
    allowed_characters = Regexp.escape( '+-*/.()^' )
    input.gsub( /[^\d#{allowed_characters}]/, '' )
  end

  def parentheses_match?(input)
    input.count('(') == input.count(')')
  end
end