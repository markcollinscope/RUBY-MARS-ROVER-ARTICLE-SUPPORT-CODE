
class Pair
  attr_reader :x, :y

  def initialize(x,y)
    @x, @y = x, y
  end
  
  def +(p) 
    return Pair.new(x+p.x, y+p.y)
  end
  
  def ==(p)
     return (x == p.x) && (y == p.y)
   end
end