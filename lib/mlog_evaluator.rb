require 'lib/mlog_grammar'
require 'lib/mlog_tokenizer'
require 'lib/mlog_parser'
#require 'ruby-debug'
class MlogEvaluator < Dhaka::Evaluator
  attr_accessor :user, :sdate, :edate

	def parse_error_msg parse_error
    "state = <#{parse_error.parser_state}>" <<
    "token = <#{parse_error.unexpected_token}>"
	end

	def tokenize_error_msg tok_error
    "char_index = <#{tok_error.unexpected_char_index}>"
	end

  def run src
		return 0 if src == ''
		toks = MlogTokenizer.tokenize(src)
		if toks.has_error?
			return tokenize_error_msg(toks)
		end
		parse_tree = MlogParser.parse(toks)
		if parse_tree.has_error?
			return parse_error_msg(parse_tree)
		end
	  evaluate(parse_tree)
	end

	def initialize user, sdate, edate
		@user, @sdate, @edate = user, sdate, edate
	end

  self.grammar = MlogGrammar

  define_evaluation_rules do

	 for_subtraction do
		 evaluate(child_nodes[0]) - evaluate(child_nodes[2])
	 end

	 for_addition do
		 evaluate(child_nodes[0]) + evaluate(child_nodes[2])
	 end

	 for_division do
		 evaluate(child_nodes[0]).to_f/evaluate(child_nodes[2])
	 end

	 for_multiplication do
		 evaluate(child_nodes[0]) * evaluate(child_nodes[2])
	 end

	 for_tag do
		 tag = child_nodes[0].token.value
		 Mlog.tagsum @user, @sdate, @edate, tag
	 end

	 for_tag_with_function do
		 #debugger
		 tag = child_nodes[0].token.value
		 function = child_nodes[2].token.value

		 Mlog.send "tag#{function}".to_sym, @user, @sdate, @edate, tag
	 end

	 for_number do
		 number = child_nodes[0].token.value
	 end

	 for_parenthetized_expression do
		 evaluate(child_nodes[1])
	 end

	 for_negated_expression do
		 -evaluate(child_nodes[1])
	 end

	 for_power do
		 evaluate(child_nodes[0])**evaluate(child_nodes[2])
	 end

  end

end
