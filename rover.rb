require 'pair'

class Rover
  
  MOVEVECTOR = Hash[
    :north => Pair.new(0,1),
    :south => Pair.new(0,-1),
    :east => Pair.new(1,0),
    :west => Pair.new(-1,0)
  ]
  
  HOWTOTURN = Hash[
    :north => Hash[:left => :west, :right => :east],
    :south => Hash[:left => :east, :right => :west],
    :east => Hash[:left => :north, :right => :south],
    :west => Hash[:left => :south, :right => :north]
  ]
  
  attr_reader :location, :direction
  
  def self.availableDirections
     return [:north, :south, :east, :west]
  end
  
  def initialize(p,d)
    @location = p 
    @direction = d
  end
  
  def moveVector(direction)
    return MOVEVECTOR[direction]
  end
  
  def move()
    @location += MOVEVECTOR[@direction]
  end
  
  def turn(whichway)
    @direction = HOWTOTURN[@direction][whichway]
  end
end
