class Object
  
  def apply 
    yield self
    return self
  end
  
end