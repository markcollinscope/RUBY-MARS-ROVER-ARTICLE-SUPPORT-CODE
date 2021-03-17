require 'test/unit'
require 'rover'

class TestRover < Test::Unit::TestCase
  NMOVES = 10
  XSTART, YSTART = 3, 5 

  def testRoverMovementInAllDirections
    Rover.availableDirections.each do |d|
        doTestMove(d)
    end
  end
    
  def testRoverInitialization
     r = Rover.new(Pair.new(XSTART,YSTART),:north)
     assert_equal(r.location.x, XSTART)
     assert_equal(r.location.y,YSTART)
  end
   
  def testLeftRight
    Rover.availableDirections.each do |d|
      r = Rover.new(Pair.new(0,0), d)
      case d
        when :north:
          r.turn(:left)
          assert(r.direction == :west)
          r.turn(:right)
          assert(r.direction == :north)
        when :south
          r.turn(:left)
          assert(r.direction == :east)
          r.turn(:right)
          assert(r.direction == :south)
        when :east
         r.turn(:left)
          assert(r.direction == :north)
          r.turn(:right)
          assert(r.direction == :east)
        when :west
          r.turn(:left)
          assert(r.direction == :south)
          r.turn(:right)
          assert(r.direction == :west)
        else
          raise RuntimeError.new
        end  
      end
  end
 
private
  def doMove(r, nTimes)
    nTimes.times do r.move() end
  end
  
  def doTestMove(direction)
    beginLocation = Pair.new(XSTART,YSTART)
    r = Rover.new(beginLocation,direction)
    doMove(r, NMOVES)
    assert_equal(beginLocation.x, r.location.x - (NMOVES * r.moveVector(direction).x))
    assert_equal(beginLocation.y, r.location.y - (NMOVES * r.moveVector(direction).y))
  end
end
