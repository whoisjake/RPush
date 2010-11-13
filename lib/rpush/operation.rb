module RPush
  class Operation
    attr_accessor :name, :arg_count, :function
    
    def initialize(name,arg_count,function)
      @name = name
      @arg_count = arg_count
      @function = function
    end
    
    def apply(args)
      @function.call(args)
    end
    
  end
end