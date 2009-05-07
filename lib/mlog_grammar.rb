require 'dhaka'
class MlogGrammar < Dhaka::Grammar
 precedences do
	 left ['+', '-']
	 left ['*', '/']
	 nonassoc ['^']
 end

 for_symbol(Dhaka::START_SYMBOL_NAME) do
	 expression ['E']
	 empty_string ['_End_']
 end

 for_symbol('E') do
	 addition ['E', '+', 'E']
	 subtraction ['E', '-', 'E']
	 multiplication ['E', '*', 'E']
	 division ['E', '/', 'E']
	 power ['E', '^', 'E']
	 tag [:identifier]
	 number [:number_literal]
	 parenthetized_expression ['(', 'E', ')']
	 negated_expression ['-', 'E'], :prec => '*'
	 tag_with_function [:identifier, '.', :identifier]
 end
end
