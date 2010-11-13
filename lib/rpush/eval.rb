module RPush
  module_function
  def eval(code,env = Environment.new)
    env.stacks[:exec] = code
    while(item = env.stacks[:exec].shift)
      if item.is_a? RPush::Instruction
        env.apply(item)
      elsif item.is_a? RPush::Atom
        env.push(item.type,item.value)
      elsif item.is_a? Array
        env.stacks[:exec] = item + env.stacks[:exec]
      else
        raise "Invalid code #{item.inspect}"
      end
    end
    env
  end
end