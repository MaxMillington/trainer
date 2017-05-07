require 'pry'

class Calculator
  attr_accessor :value
  attr_accessor :match_value

  def evaluate(input)
    return if input.nil? || input.class != String
    return unless parentheses_match?(input)
    return format(input) if finished?(input)
    clean_input = remove_spaces_and_non_allowed_characters(input)

    add_subtract, exponent, multiply_divide = get_operator_variables(clean_input)

    if exponent
      match_value = exponent
      value = perform_exponent_calc(match_value) if exponent
    elsif multiply_divide
      match_value = multiply_divide
      value = perform_multiplication_division_calc(match_value) if multiply_divide
    elsif add_subtract
      match_value = add_subtract
      value = perform_addition_subtraction_calc(match_value) if add_subtract
    end

    new_input = match_value ? clean_input.sub(match_value[0], value.to_s) : value
    evaluate(new_input)
  end

  private

  def get_operator_variables(clean_input)
    exponent = clean_input.match(/([0-9]*\.?[0-9]*)([\^])(-?[0-9]*\.?[0-9]*)/)
    multiply_divide = clean_input.match(/([0-9]*\.?[0-9]*)([\*\/])(-?[0-9]*\.?[0-9]*)/)
    add_subtract = clean_input.match(/(\-?[0-9]*\.?[0-9]*)([\+\-])([0-9]*\.?[0-9]*)/)
    return add_subtract, exponent, multiply_divide
  end

  def finished?(input)
    !input.match(/[+-\/*^]/) || (input.scan(/[+-\/*^]/)[0] == '.' && input.scan(/[+-\/*^]/).size < 2)
  end

  def format(input)
    input = input.to_f
    input.to_i == input ? input.to_i : input
  end

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