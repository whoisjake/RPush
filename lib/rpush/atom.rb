module RPush
  class Atom
    attr_reader :type,:value
    def initialize(type,value)
      @type = type
      @value = value
    end
    
    def ==(another)
      unless another.is_a? Atom
        super(another)
      end
      self.value == another.value
    end
    
    def eql?(another)
      unless another.is_a? Atom
        return false
      end
      self.value.eql?(another.value)
    end
    
  end
end