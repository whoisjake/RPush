module RPush
  class Environment
  
    attr_reader :stacks, :operations, :bindings
  
    def initialize
      @stacks = {}
      @operations = {}
      create_default_operations!
      @bindings = {}
    end
    
    def push(stack,value)
      @stacks[stack] ||= []
      @stacks[stack] << value
    end
    
    def pop(stack)
      @stacks[stack].pop
    end
    
    def size_of(stack)
      @stacks[stack].nil? ? 0 : @stacks[stack].size
    end
    
    def apply(instruction)
      type,operator = instruction.value.split(".")
      case type
      when "CODE"
      when "EXEC"
      when "INTEGER","FLOAT","BOOLEAN"
        func = @operations[type.downcase.to_sym][operator.upcase.to_sym]
        operands = []
        stack = type.downcase.to_sym
        if size_of(stack) >= func.arg_count
          func.arg_count.times do
            val = pop(type.downcase.to_sym)
            if val.nil?
              raise "Not enough values on #{type} stack"
            end
            operands << val
          end
          stack,value = func.apply(operands)
          unless stack == :noop
            push(stack,value)
          end
        end
      else # it's a name
        if @bindings[type]
          # either retrieve value
          push(:exec,@bindings[type])
        else
          # or push onto NAME stack
          push(:name,type)
        end
      end
    end
    
    def to_s
      s = "Environment\n"
      @stacks.keys.each do |stack|
        s += "#{stack.to_s.upcase} STACK: (#{@stacks[stack].join(",")})\n"
      end
      s
    end
    
    def create_default_operations!
      @operations = {}
      
      @operations[:integer] = {}
      @operations[:integer][:'+'] = Operation.new("+",2, lambda {|args| [:integer,args[0] + args[1]]})
      @operations[:integer][:'-'] = Operation.new("-",2, lambda {|args| [:integer,args[1] - args[0]]})
      @operations[:integer][:'*'] = Operation.new("*",2, lambda {|args| [:integer,args[0] * args[1]]})
      @operations[:integer][:'/'] = Operation.new("/",2, lambda {|args| args[1] == 0 ? [:noop] : [:integer, args[0] /args[1]]})
      @operations[:integer][:'%'] = Operation.new("%",2, lambda {|args| args[1] == 0 ? [:noop] : [:integer, args[0] % args[1]]})
      @operations[:integer][:'<'] = Operation.new("<",2, lambda {|args| [:boolean,args[0] < args[1]]})
      @operations[:integer][:'='] = Operation.new("=",2, lambda {|args| [:boolean,args[0] = args[1]]})
      @operations[:integer][:'>'] = Operation.new(">",2, lambda {|args| [:boolean,args[0] > args[1]]})
      @operations[:integer][:DUP] = Operation.new("dup",0,lambda {|args| [:integer,@stacks[:integer][0]]})
      @operations[:integer][:FLUSH] = Operation.new("flush",0,lambda {|args| @stacks[:integer] = []; [:noop] })
      @operations[:integer][:POP] = Operation.new("pop",0,lambda {|args| @stacks[:integer].pop; [:noop] })
      @operations[:integer][:FROMBOOLEAN] = Operation.new("fromboolean",0,lambda {|args| [:integer,@stacks[:boolean].pop ? 1 : 0]})
      @operations[:integer][:FROMFLOAT] = Operation.new("fromfloat",0,lambda {|args| [:integer,@stacks[:float].pop.to_i]})
      @operations[:integer][:STACKDEPTH] = Operation.new("stackdepth",0,lambda {|args| [:integer,@stacks[:integer].size]})
      @operations[:integer][:MAX] = Operation.new("max",2,lambda {|args| [:integer,args.max]})
      @operations[:integer][:MIN] = Operation.new("min",2,lambda {|args| [:integer,args.min]})
      @operations[:integer][:SWAP] = Operation.new("swap",2,lambda{|args| push(:integer,args[0]); push(:integer,args[1]); [:noop]})
      @operations[:integer][:DEFINE]
      @operations[:integer][:RAND]
      @operations[:integer][:ROT]
      @operations[:integer][:SHOVE]
      @operations[:integer][:YANK]
      @operations[:integer][:YANKDUP]
      
      @operations[:float] = {}
      @operations[:float][:'+'] = Operation.new("+",2, lambda {|args| [:float,args[0] + args[1]]})
      @operations[:float][:'-'] = Operation.new("-",2, lambda {|args| [:float,args[0] - args[1]]})
      @operations[:float][:'*'] = Operation.new("*",2, lambda {|args| [:float,args[0] * args[1]]})
      @operations[:float][:'/'] = Operation.new("/",2, lambda {|args| args[1] == 0 ? [:noop] : [:float, args[0] /args[1]]})
      @operations[:float][:'%'] = Operation.new("%",2, lambda {|args| args[1] == 0 ? [:noop] : [:float, args[0] % args[1]]})
      @operations[:float][:'<'] = Operation.new("<",2, lambda {|args| [:boolean,args[0] < args[1]]})
      @operations[:float][:'='] = Operation.new("=",2, lambda {|args| [:boolean,args[0] = args[1]]})
      @operations[:float][:'>'] = Operation.new(">",2, lambda {|args| [:boolean,args[0] > args[1]]})
      @operations[:float][:DUP] = Operation.new("dup",0,lambda {|args| [:float,@stacks[:float][0]]})
      @operations[:float][:FLUSH] = Operation.new("flush",0,lambda {|args| @stacks[:float] = []; [:noop] })
      @operations[:float][:POP] = Operation.new("pop",0,lambda {|args| @stacks[:float].pop; [:noop] })
      @operations[:float][:FROMBOOLEAN] = Operation.new("fromboolean",0,lambda {|args| [:float,@stacks[:boolean].pop ? 1 : 0]})
      @operations[:float][:FROMINTEGER] = Operation.new("frominteger",0,lambda {|args| [:float,@stacks[:integer].pop.to_f]})
      @operations[:float][:SIN] = Operation.new("sin",1,lambda {|args| [:float,Math.sin(args[0])]})
      @operations[:float][:COS] = Operation.new("cos",1,lambda {|args| [:float,Math.cos(args[0])]})
      @operations[:float][:TAN] = Operation.new("tan",1,lambda {|args| [:float,Math.tan(args[0])]})
      @operations[:float][:STACKDEPTH] = Operation.new("stackdepth",0,lambda {|args| [:integer,@stacks[:float].size]})
      @operations[:float][:MAX] = Operation.new("max",2,lambda {|args| [:float,args.max]})
      @operations[:float][:MIN] = Operation.new("min",2,lambda {|args| [:float,args.min]})
      @operations[:float][:SWAP] = Operation.new("swap",2,lambda{|args| push(:float,args[0]); push(:float,args[1]); [:noop]})
      @operations[:float][:DEFINE]
      @operations[:float][:RAND]
      @operations[:float][:ROT]
      @operations[:float][:SHOVE]
      @operations[:float][:YANK]
      @operations[:float][:YANKDUP]
      
      @operations[:boolean] = {}
      @operations[:boolean][:'='] = Operation.new("=",2, lambda {|args| [:boolean,args[0] == args[1]]})
      @operations[:boolean][:AND] = Operation.new("and",2, lambda {|args| [:boolean,args[0] && args[1]]})
      @operations[:boolean][:DEFINE]
      @operations[:boolean][:DUP] = Operation.new("dup",0,lambda {|args| [:boolean,@stacks[:boolean][0]]})
      @operations[:boolean][:FLUSH] = Operation.new("flush",0,lambda {|args| @stacks[:boolean] = []; [:noop] })
      @operations[:boolean][:FROMFLOAT] = Operation.new("fromfloat",0,lambda {|args| [:boolean,@stacks[:float].pop == 0.0]})
      @operations[:boolean][:FROMINTEGER] = Operation.new("frominteger",0,lambda {|args| [:boolean,@stacks[:integer].pop == 0]})
      @operations[:boolean][:NOT] = Operation.new("not",1, lambda {|args| [:boolean,!args[0]]})
      @operations[:boolean][:OR] = Operation.new("and",2, lambda {|args| [:boolean,args[0] || args[1]]})
      @operations[:boolean][:POP] = Operation.new("pop",0,lambda {|args| @stacks[:boolean].pop; [:noop] })
      @operations[:boolean][:RAND]
      @operations[:boolean][:ROT]
      @operations[:boolean][:SHOVE]
      @operations[:boolean][:STACKDEPTH] = Operation.new("stackdepth",0,lambda {|args| [:integer,@stacks[:boolean].size]})
      @operations[:boolean][:SWAP] = Operation.new("swap",2,lambda{|args| push(:boolean,args[0]); push(:boolean,args[1]); [:noop]})
      @operations[:boolean][:YANK]
      @operations[:boolean][:YANKDUP]
      
      @operations[:name] = {}
      @operations[:name][:'=']
      @operations[:name][:DUP]
      @operations[:name][:FLUSH]
      @operations[:name][:POP]
      @operations[:name][:QUOTE]
      @operations[:name][:RAND]
      @operations[:name][:RANDBOUNDNAME]
      @operations[:name][:ROT]
      @operations[:name][:SHOVE]
      @operations[:name][:STACKDEPTH]
      @operations[:name][:SWAP]
      @operations[:name][:YANK]
      @operations[:name][:YANKDUP]
      
      @operations[:code] = {}
      @operations[:code][:'=']
      @operations[:code][:APPEND]
      @operations[:code][:ATOM]
      @operations[:code][:CAR]
      @operations[:code][:CDR]
      @operations[:code][:CONS]
      @operations[:code][:CONTAINER]
      @operations[:code][:CONTAINS]
      @operations[:code][:DEFINE]
      @operations[:code][:DEFINITION]
      @operations[:code][:DISCREPANCY]
      @operations[:code][:DO]
      @operations[:code][:'DO*']
      @operations[:code][:'DO*COUNT']
      @operations[:code][:'DO*RANGE']
      @operations[:code][:'DO*TIMES']
      @operations[:code][:DUP]
      @operations[:code][:EXTRACT]
      @operations[:code][:FLUSH]
      @operations[:code][:FROMBOOLEAN]
      @operations[:code][:FROMFLOAT]
      @operations[:code][:FROMINTEGER]
      @operations[:code][:FROMNAME]
      @operations[:code][:IF]
      @operations[:code][:INSERT]
      @operations[:code][:INSTRUCTIONS]
      @operations[:code][:LENGTH]
      @operations[:code][:LIST]
      @operations[:code][:MEMBER]
      @operations[:code][:NOOP]
      @operations[:code][:NTH]
      @operations[:code][:NTHCDR]
      @operations[:code][:NULL]
      @operations[:code][:POP]
      @operations[:code][:POSITION]
      @operations[:code][:QUOTE]
      @operations[:code][:RAND]
      @operations[:code][:ROT]
      @operations[:code][:SHOVE]
      @operations[:code][:SIZE]
      @operations[:code][:STACKDEPTH]
      @operations[:code][:SUBST]
      @operations[:code][:SWAP]
      @operations[:code][:YANK]
      @operations[:code][:YANKDUP]
      
      @operations[:exec] = {}
      @operations[:exec][:'=']
      @operations[:exec][:DEFINE]
      @operations[:exec][:'DO*COUNT']
      @operations[:exec][:'DO*RANGE']
      @operations[:exec][:'DO*TIMES']
      @operations[:exec][:DUP]
      @operations[:exec][:FLUSH]
      @operations[:exec][:IF]
      @operations[:exec][:K]
      @operations[:exec][:POP]
      @operations[:exec][:ROT]
      @operations[:exec][:S]
      @operations[:exec][:SHOVE]
      @operations[:exec][:STACKDEPTH]
      @operations[:exec][:SWAP]
      @operations[:exec][:Y]
      @operations[:exec][:YANK]
      @operations[:exec][:YANKDUP]
    end
  
  end
end