require 'dhaka'
class MlogTokenizer < Dhaka::Tokenizer
	digits     = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.']
  operators  = ['-', '+', '/', '*', '^']
  whitespace = [' ']

  for_state Dhaka::TOKENIZER_IDLE_STATE do
		for_characters digits do
      create_token(:number_literal, curr_char)
			advance
			if curr_char.nil?
			  l = tokens.length - 1
				tokens[l].value= tokens[l].value.to_f
			end
			switch_to :get_number_literal
		end

    for_characters operators do 
      create_token(curr_char, curr_char)
      advance
    end

    for_character whitespace do
      advance
    end

	  for_default do
			unless curr_char.nil?
				create_token(:identifier, curr_char)
				advance
				switch_to :get_identifier
			end
	  end
   end

   for_state :get_number_literal do
		 for_characters digits do
       curr_token.value << curr_char
			 advance
			 if curr_char.nil?
				 l = tokens.length - 1
				 tokens[l].value= tokens[l].value.to_f
			 end
		 end

     for_default do
			 curr_token.value = curr_token.value.to_f
       switch_to Dhaka::TOKENIZER_IDLE_STATE
     end
	 end

   for_state :get_identifier do
     for_characters operators + whitespace do
       switch_to Dhaka::TOKENIZER_IDLE_STATE
     end
		 for_characters '.' do
			 create_token(curr_char, curr_char)
			 advance
       switch_to Dhaka::TOKENIZER_IDLE_STATE
		 end
     for_default do
       curr_token.value << curr_char
       advance
     end
   end
end
