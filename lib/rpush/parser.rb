module RPush
  
  class Parser

    def parse(input)
      interpret(tokenize(input))
    end
    
    def tokenize(input)
      input.chomp.gsub('(',' ( ').gsub(')',' ) ').split
    end
    
    def interpret(tokens)
      if tokens.nil? || tokens.empty?
        raise 'Unexpected end of file.'
      end
      token = tokens.shift
      case token
      when '('
        interpreted = []
        while( tokens[0] != ')')
          interpreted << interpret(tokens)
        end
        tokens.shift
        return interpreted
      when ')'
        raise 'Unepxected )'
      else
        return atom(token)
      end
    end
    
    def atom(token)
      case token
      when /^TRUE$/
        RPush::Atom.new(:boolean,true)
      when /^FALSE$/
        RPush::Atom.new(:boolean,false)
      when /^\d+$/
        RPush::Atom.new(:integer,token.to_i)
      when /^\d+\.\d+$/
        RPush::Atom.new(:float,token.to_f)
      else
        RPush::Instruction.new(:instruction,token)
      end
    end
    
  end

end