require 'pair'
require 'rover'

module MarsGrid
    class GridRoverIdError < RuntimeError
    attr_reader :roverId
    def initialize(rid)
      @roverId = rid
    end
  end
  
  class GridError < RuntimeError
	  attr_reader :roverId, :x, :y
     def initialize(roverId,x,y)
      @roverId = roverId
      @x = x
      @y = y
    end
  end
  
	class GridBoundaryError < GridError; end
	class GridCollisionError < GridError; end
  
	class Grid
    attr_reader :size
  
    def initialize(size)
      @size = size
      @rovers = Array.new
    end
    
    def addRover(location,direction)
       r = Rover.new(location,direction)
      @rovers.push(r)
      rid = nRovers - 1
      checkIfOutsideGrid(rid)
      checkIfInCollision(rid)
      return rid
    end
		
		def moveRover(rid)
      checkRoverId(rid)
			@rovers[rid].move()
			checkIfOutsideGrid(rid)
			checkIfInCollision(rid)
		end
    
    def turnRover(rid,direction)
      checkRoverId(rid)
      @rovers[rid].turn(direction)
    end
    
    def roverPosition(rid)
      checkRoverId(rid)
      return @rovers[rid].location
    end
    
    def roverDirection(rid)
      checkRoverId(rid)
      return @rovers[rid].direction
    end

    def nRovers
        return @rovers.length
     end
      
     def rovers
        arr = Array.new
        for i in 0 ... nRovers do
           arr.push(i)
         end
         return arr
      end

  private
    def checkRoverId(rid)
      if ((rid < 0) || (nRovers <= rid))
          grie = GridRoverIdError.new(rid)
          raise grie, "Software error - ask for your money back", caller
      end
    end
  
    def checkIfInCollision(rid)
      checkRoverId(rid)
      r = @rovers[rid]
      for i in 0 ... nRovers
        otherRover = @rovers[i]
        if ((i != rid) && (otherRover.location == r.location))
					gce = GridCollisionError.new(rid,r.location.x,r.location.y)
				  raise gce, "Error: collision between rovers", caller
				end
			end
		end

    def checkIfOutsideGrid(rid)
			checkRoverId(rid)
      r = @rovers[rid]
      if (
				(r.location.x >= @size.x) ||
				(r.location.y >= @size.y) ||
				(r.location.x < 0) ||
				(r.location.y < 0)
			)
			then
				gbe = GridBoundaryError.new(rid,r.location.x,r.location.y)
				raise gbe, "Error: Rover out of grid bounds", caller
			end
    end
  end
end