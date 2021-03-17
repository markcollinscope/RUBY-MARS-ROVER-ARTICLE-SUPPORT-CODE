require 'test/unit'
require 'grid'

class TestGrid < Test::Unit::TestCase
  XGRIDSIZE , YGRIDSIZE = 1200, 2000
  NROVERS = 1000

  def testAddingRovers
    assert(
      NROVERS < XGRIDSIZE && NROVERS < YGRIDSIZE, 
      "Test assumption violated - constant values incorrect"    
    )
    g = MarsGrid::Grid.new(Pair.new(XGRIDSIZE,YGRIDSIZE))
    NROVERS.times do |n|
      g.addRover(Pair.new(n,n),:north)
    end
    assert_equal(NROVERS, g.nRovers)
  end
  
  def testGridBoundaryError
    doTestGridBoundaryError(XGRIDSIZE, 0)
    doTestGridBoundaryError(0, YGRIDSIZE)
    doTestGridBoundaryError(-1,0)
    doTestGridBoundaryError(0,-1)
  end
  
  MULT = 100
  def testDataInGridBoundaryError
    assert(MULT > 0)
    begin
      g = MarsGrid::Grid.new(Pair.new(XGRIDSIZE,YGRIDSIZE))
      g.addRover(Pair.new(XGRIDSIZE*MULT,YGRIDSIZE*MULT), :east)
    rescue MarsGrid::GridBoundaryError => gbe
       assert_equal(gbe.roverId, 0)
       assert_equal(gbe.x, XGRIDSIZE*MULT)
       assert_equal(gbe.y, YGRIDSIZE*MULT)
    end
  end

  def testMoveRoverBoundaryError
    g = MarsGrid::Grid.new(Pair.new(XGRIDSIZE,YGRIDSIZE))
    
    doTestBoundaryErrorWhenMoveRover(g, YGRIDSIZE, :north, Pair.new(0,0))
    doTestBoundaryErrorWhenMoveRover(g, XGRIDSIZE, :west,Pair.new(0,0))
    doTestBoundaryErrorWhenMoveRover(
      g, YGRIDSIZE, :south, Pair.new(XGRIDSIZE-1,YGRIDSIZE-1)
    )
    doTestBoundaryErrorWhenMoveRover(
      g, XGRIDSIZE, :east, Pair.new(XGRIDSIZE-1,YGRIDSIZE-1)
    )
  end
  
  def testAddCollision
    g = MarsGrid::Grid.new(Pair.new(XGRIDSIZE,YGRIDSIZE))
    assert_raise MarsGrid::GridCollisionError do
      g.addRover(Pair.new(0,0),:south)
      g.addRover(Pair.new(0,0),:east)
    end
  end
    
  XPOS, YPOS = 100,200
  def testMoveCollision
    assert (XPOS < XGRIDSIZE && YPOS < YGRIDSIZE)
    g = MarsGrid::Grid.new(Pair.new(XGRIDSIZE,YGRIDSIZE))
    firstRover = g.addRover(Pair.new(XPOS,YPOS),:east)
    secondRover = g.addRover(Pair.new(0,0),:east)
    assert_raise MarsGrid::GridCollisionError do
      XPOS.times do g.moveRover(secondRover) ; end
      g.turnRover(secondRover,:left)
      YPOS.times do g.moveRover(secondRover) ; end
    end
  end
  
  def testDataInGridCollisionError
    assert (XPOS < XGRIDSIZE - 2 && YPOS < YGRIDSIZE - 2)
    begin
      g = MarsGrid::Grid.new(Pair.new(XGRIDSIZE,YGRIDSIZE))
      firstRoverId = g.addRover(Pair.new(XPOS,YPOS),:west)
      secondRoverId = g.addRover(Pair.new(XPOS,YPOS),:west)
    rescue MarsGrid::GridCollisionError => gce
      assert_equal(gce.x, XPOS)
      assert_equal(gce.y, YPOS)
    end
    begin
      thirdRoverId = g.addRover(Pair.new(XPOS+1,YPOS+1),:south)
      fourthRoverId = g.addRover(Pair.new(XPOS+2,YPOS+2),:west)
      g.moveRover(fourthRoverId)
      g.moveRover(fourthRoverId)
    rescue MarsGrid::GridCollisionError => gbe
      assert_equal(gbe.roverId, fourthRoverId)
      assert_equal(gbe.x, XPOS+1)
      assert_equal(gbe.y, YPOS+1)
    end
  end
  
  def testRoverArrayReturn
    assert(NROVERS < XGRIDSIZE && NROVERS < YGRIDSIZE)
    aGrid = MarsGrid::Grid.new(Pair.new(XGRIDSIZE,YGRIDSIZE))
    NROVERS.times do |n|
      aGrid.addRover(Pair.new(n,n),:north)
    end
    assert(aGrid.rovers().length == NROVERS)
  end
  
private
  def doTestGridBoundaryError(x,y)
    g = MarsGrid::Grid.new(Pair.new(XGRIDSIZE,YGRIDSIZE))
    assert_raise MarsGrid::GridBoundaryError do
      g.addRover(Pair.new(x,y),:east)
    end    
  end
  
    def doTestBoundaryErrorWhenMoveRover(aGrid, nMoves, direction, startLocation)
    rover = aGrid.addRover(Pair.new(startLocation.x,startLocation.y),direction)
    assert_raise MarsGrid::GridBoundaryError do
      nMoves.times do
        aGrid.moveRover(rover)
      end
    end
  end
end