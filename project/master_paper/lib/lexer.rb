# =Lexer 
# metaprogramming 
# 指能以程式語言為新的問題領域建立其專用的程式語言。
# 能進行後設程式的語言是能建立以下三個程式語言的元件：
# 詞
# 表示式
# 區塊
#
# 
#
# Example.
# lex = Lexer do
#		rule /[0-9]*/, :number
# end
#
# 一個轉換規則的語法為
# TokenType RegExp Action
# Example.
# lex = Lexer do
#   number /[0-9]*/
# end
require 'rubygems'
require 'facets/proc/bind'

class Lexer

	class Error < RuntimeError
	end

	class Rule
    attr_accessor :type, :pattern, :definition
		def initialize type, pattern, definition
			@type, @pattern, @definition = type, pattern, definition
		end
	end
	def Rule type, pattern, definition
    Rule.new type, pattern, definition
  end

  class Token
	  attr_accessor :lexeme, :type
		def initialize lexeme, type
			@lexeme, @type = lexeme, type
		end
	end
	def Token lexeme, type
    Token.new lexeme, type
  end

	class Builder
	  attr_accessor :lexer
    def initialize
			@lexer = Lexer.new
		end

		def method_missing type, *args
      @lexer.define_rule type, args[0]
		end
	end

	attr_accessor :source
	def initialize
		@rules = [Rule(:blank, /\s/, '\s')]
	end

	def [] rule_type
		@rules.find { |r| r.type == rule_type }
	end

  def define_rule type, definition
		raise Error, "definition cannot be nil" if definition.nil?
		pattern = Regexp.new expand_rule_definition(definition)
    @rules.push Rule(type, pattern, definition)
	end
	
	# :number '[0-9]'
	# definition like 'abc[:number]+def' 
	# will be expand to 'abc([0-9])+def' 
	# [:rule_type] is called rule variable, 
	# will insert its definition as grouping
	#
	# the definition cannot 
	# include the latter rule variable
	#
	def expand_rule_definition definition
		@rules.reverse_each do |r|
      definition = definition.gsub "[:#{r.type.to_s}]", "(#{r.definition})"
		end
		definition
	end

	def begin
    @unreadstr = @source
	end

	def next
		raise Error, "at end of the source" if self.end?
    @rules.each do |r|
			type = r.type
			pattern = r.pattern
		  #debugger
			pattern.match @unreadstr
			if $` == ''
        lexeme = $&
				@unreadstr = $'
				unless (lexeme.nil? || type == :blank)
					return Token(lexeme, type)
				end
			end
		end
	end

	def end?
    @unreadstr == ''
  end

	def read source
		@source = source
		self.begin
	end
end

def Lexer &block
  builder = Lexer::Builder.new
	block.bind(builder).call
	builder.lexer
end
