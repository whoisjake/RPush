module RPush
  class Environment
  
    attr_reader :stacks, :operations, :bindings
  
    def initialize
      @stacks = {}
      @operations = {}
      load_default_operations
      @bindings = {}
    end
    
    def push(stack,value)
      @stacks[stack] ||= []
      @stacks[stack] << value
    end
    
    def apply(instruction)
      type,operator = instruction.value.split(".")
      case type
      when "CODE"
      when "EXEC"
      when "INTEGER","FLOAT","BOOLEAN"
        func = @operations[type.downcase.to_sym][operator.downcase.to_sym]
        operands = []
        func.arg_count.times do
          val = @stacks[type.downcase.to_sym].pop
          if val.nil?
            raise "Not enough values on #{type} stack"
          end
          operands << val
        end
        stack,value = func.apply(operands)
        unless stack == :noop
          push(stack,value)
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
      puts "Environment"
      @stacks.keys.each do |stack|
        puts "#{stack.to_s.upcase} STACK: (#{@stacks[stack].join(",")})"
      end
    end
    
    private
    
    def load_default_operations
      @operations[:integer] = {}
      @operations[:integer][:'+'] = Operation.new("+",2, lambda {|args| [:integer,args[0] + args[1]]})
      @operations[:integer][:'-'] = Operation.new("-",2, lambda {|args| [:integer,args[0] - args[1]]})
      @operations[:integer][:'*'] = Operation.new("*",2, lambda {|args| [:integer,args[0] * args[1]]})
      @operations[:integer][:'/'] = Operation.new("/",2, 
        lambda do |args|
          if args[1] == 0
            return [:noop]
          end
          [:integer,args[0] / args[1]]
        end)
      @operations[:integer][:'%'] = Operation.new("%",2, 
        lambda do |args|
          if args[1] == 0
            return [:noop]
          end
          [:integer,args[0] % args[1]]
        end)
      @operations[:integer][:'<'] = Operation.new("<",2, lambda {|args| [:boolean,args[0] < args[1]]})
      @operations[:integer][:'='] = Operation.new("=",2, lambda {|args| [:boolean,args[0] = args[1]]})
      @operations[:integer][:'>'] = Operation.new(">",2, lambda {|args| [:boolean,args[0] > args[1]]})
      @operations[:integer][:dup] = Operation.new("dup",0,lambda {|args| [:integer,@stacks[:integer][0]]})
      @operations[:integer][:flush] = Operation.new("flush",0,lambda {|args| @stacks[:integer] = []; [:noop] })
      @operations[:integer][:pop] = Operation.new("pop",0,lambda {|args| @stacks[:integer].pop; [:noop] })
      @operations[:integer][:fromboolean] = Operation.new("fromboolean",0,lambda {|args| [:integer,@stacks[:boolean].pop ? 1 : 0]})
      @operations[:integer][:fromfloat] = Operation.new("fromfloat",0,lambda {|args| [:integer,@stacks[:float].pop.to_i]})
      @operations[:integer][:stackdepth] = Operation.new("stackdepth",0,lambda {|args| [:integer,@stacks[:integer].size]})
      @operations[:integer][:max] = Operation.new("max",2,lambda {|args| [:integer,args.max]})
      @operations[:integer][:min] = Operation.new("min",2,lambda {|args| [:integer,args.min]})
      
      @operations[:float] = {}
      @operations[:float][:'+'] = Operation.new("+",2, lambda {|args| [:float,args[0] + args[1]]})
      @operations[:float][:'-'] = Operation.new("-",2, lambda {|args| [:float,args[0] - args[1]]})
      @operations[:float][:'*'] = Operation.new("*",2, lambda {|args| [:float,args[0] * args[1]]})
      @operations[:float][:'/'] = Operation.new("/",2, 
        lambda do |args|
          if args[1] == 0
            return [:noop]
          end
          [:float,args[0] / args[1]]
        end)
      @operations[:float][:'%'] = Operation.new("%",2, 
        lambda do |args|
          if args[1] == 0
            return [:noop]
          end
          [:float,args[0] % args[1]]
        end)
      @operations[:float][:'<'] = Operation.new("<",2, lambda {|args| [:boolean,args[0] < args[1]]})
      @operations[:float][:'='] = Operation.new("=",2, lambda {|args| [:boolean,args[0] = args[1]]})
      @operations[:float][:'>'] = Operation.new(">",2, lambda {|args| [:boolean,args[0] > args[1]]})
      @operations[:float][:dup] = Operation.new("dup",0,lambda {|args| [:float,@stacks[:float][0]]})
      @operations[:float][:flush] = Operation.new("flush",0,lambda {|args| @stacks[:float] = []; [:noop] })
      @operations[:float][:pop] = Operation.new("pop",0,lambda {|args| @stacks[:float].pop; [:noop] })
      @operations[:float][:fromboolean] = Operation.new("fromboolean",0,lambda {|args| [:float,@stacks[:boolean].pop ? 1 : 0]})
      @operations[:float][:frominteger] = Operation.new("frominteger",0,lambda {|args| [:float,@stacks[:integer].pop.to_f]})
      @operations[:float][:sin] = Operation.new("sin",1,lambda {|args| [:float,Math.sin(args[0])]})
      @operations[:float][:cos] = Operation.new("cos",1,lambda {|args| [:float,Math.cos(args[0])]})
      @operations[:float][:tan] = Operation.new("tan",1,lambda {|args| [:float,Math.tan(args[0])]})
      @operations[:float][:stackdepth] = Operation.new("stackdepth",0,lambda {|args| [:float,@stacks[:float].size]})
      @operations[:float][:max] = Operation.new("max",2,lambda {|args| [:float,args.max]})
      @operations[:float][:min] = Operation.new("min",2,lambda {|args| [:float,args.min]})
    end
  
  end
end