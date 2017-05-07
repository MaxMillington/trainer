require 'pry'

class Calculator
  attr_accessor :value
  attr_accessor :match_value

  def evaluate(input)
    return if input.nil? || input.class != String
    return unless parentheses_match?(input)
    return format(input) if finished?(input)
    clean_input = remove_spaces_and_non_allowed_characters(input)
    inner_parentheses = clean_input.match(/\(([^()]+)\)/)
    inner_input = inner_parentheses ? inner_parentheses[0] : clean_input

    add_subtract, exponent, multiply_divide, value = get_operator_variables(inner_input)

    match_value, value = order_of_operations(add_subtract, exponent, multiply_divide, value)

    new_input = match_value ? clean_input.sub(match_value[0], value.to_s) : value
    evaluate(new_input)
  end

  private

  def order_of_operations(add_subtract, exponent, multiply_divide, value)
    if value
      match_value = value
      input_with_no_left_paren = match_value[0].sub('(', '')
      value = input_with_no_left_paren.sub(')', '')
    elsif exponent
      match_value = exponent
      value = perform_exponent_calc(match_value) if exponent
    elsif multiply_divide
      match_value = multiply_divide
      value = perform_multiplication_division_calc(match_value) if multiply_divide
    elsif add_subtract
      match_value = add_subtract
      value = perform_addition_subtraction_calc(match_value) if add_subtract
    end
    return match_value, value
  end

  def get_operator_variables(input)
    value = nil
    value = input.match(/\(([^()]+)\)/)  if !input.include?('-') &&
        !input.include?('+') && !input.include?('*') &&
        !input.include?('/') && !input.include?('^')
    exponent = input.match(/([0-9]*\.?[0-9]*)([\^])(-?[0-9]*\.?[0-9]*)/)
    multiply_divide = input.match(/([0-9]*\.?[0-9]*)([\*\/])(-?[0-9]*\.?[0-9]*)/)
    add_subtract = input.match(/(\-?[0-9]*\.?[0-9]*)([\+\-])([0-9]*\.?[0-9]*)/)
    return add_subtract, exponent, multiply_divide, value
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
    new_input = input.gsub( /[^\d#{allowed_characters}]/, '' )
    new_input.gsub('--', '+')
  end

  def parentheses_match?(input)
    input.count('(') == input.count(')')
  end
end