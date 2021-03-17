require 'test/unit'
require 'parser'

class TestParser < Test::Unit::TestCase
  
  NONEXISTANTFILE = "non-existant"
  def testReadFileError
    aParser = Parser::Parser.new()
    assert_raise Parser::FileError do
      aParser.readFile(NONEXISTANTFILE)
    end
  end

  TESTLOADFILE = "parsertest.txt"
  def testLoadsTestFile
    aParser = Parser::Parser.new()
    aParser.readFile(TESTLOADFILE)
    assert(aParser.nLines == 10)
  end
  
  NLINES = 100
  def testCanSetUpTestData
    arr = Array.new
    for i in 0 ... NLINES do
      arr[i] = "ABCDE"
    end
    aParser = Parser::Parser.new()
    aParser.setUpTestData(arr)
    assert(aParser.nLines == NLINES)
  end
  
  ERRORLINE = "3 Z 4"
  def testErrorOnParseGridSize
    aParser = Parser::Parser.new()
    assert_raise Parser::SyntaxError do 
      aParser.parseGridSize(ERRORLINE,0)
    end
  end
  
  NUM1 = 200
  NUM2 = 700
  OKLINE = NUM1.to_s + " " + NUM2.to_s
  def testOkParseGridSize
    aParser = Parser::Parser.new()
    aGrid = aParser.parseGridSize(OKLINE, 0)
    assert (aGrid.size.x == NUM1+1)
    assert (aGrid.size.y == NUM2+1)
  end
    
  ERRORLINEROVER = "3 X N"
  def testErrorOnParseRoverStartLine
    aParser = Parser::Parser.new()
    aGrid = MarsGrid::Grid.new(Pair.new(NUM1,NUM2))
    assert_raise Parser::SyntaxError do 
      aParser.parseRoverStartLine(aGrid, ERRORLINEROVER, 0)
    end
  end
    
  DIR = "E"
  OKROVERLINE = (NUM1-1).to_s + " " + (NUM2-1).to_s + " " + DIR
  def testOkParseRoverStart
    aParser = Parser::Parser.new()
    aGrid = MarsGrid::Grid.new(Pair.new(NUM1,NUM2))
    rid = aParser.parseRoverStartLine(aGrid, OKROVERLINE, 0)
    doAssertRoverData(aGrid,rid,NUM1-1,NUM2-1,Parser::Parser::DIRECTIONS[DIR])
  end
  
  ERRORCMDLINE = "RLRLMMMMMRLRLMX"
  def testErrorOnParseCommandLine
    aParser = Parser::Parser.new()
    aGrid = MarsGrid::Grid.new(Pair.new(NUM1,NUM2))
    rid = aGrid.addRover(Pair.new(0,0),:north)
    assert_raise Parser::SyntaxError do 
      aParser.parseCommandLine(aGrid,rid,ERRORCMDLINE,0)
    end
  end
  
  GX = 200; GY = 300
  # given the following ...
  ROVXSTART = 10; ROVYSTART = 45; ROVSTARTDIR = :north
  ROVCMDLINE = "RMMMMMLMMMMMRRRRLLLLRLRLRLRMLMRR"
  # we can therefore expect ...
  ROVXEND = ROVXSTART + 6; ROVYEND = ROVYSTART + 6; ROVENDDIR = :south
  def testOkOnParseCommandLine
    aParser = Parser::Parser.new()
    aGrid = MarsGrid::Grid.new(Pair.new(GX,GY))
    aRover = aGrid.addRover(Pair.new(ROVXSTART,ROVYSTART),ROVSTARTDIR )
    aParser.parseCommandLine(aGrid,aRover,ROVCMDLINE,0)
    doAssertRoverData(aGrid,aRover,ROVXEND,ROVYEND,ROVENDDIR)
  end
  
  FULLTESTFILE = "unittestfullfile.txt"
  def testFullParse
    aParser = Parser::Parser.new()
    aGrid = aParser.parseMarsControlFile(FULLTESTFILE)
    n = 0
    for rid in aGrid.rovers do
      doAssertRoverData(aGrid,rid,10+n,10+n,:north)
      n += 1
    end
  end
 
private
  def doAssertRoverData(aGrid,rid,x,y,dir)
    assert (aGrid.roverPosition(rid).x == x), "x pos invalid: " + aGrid.roverPosition(rid).x.to_s + " rover: " + rid.to_s
    assert (aGrid.roverPosition(rid).y == y), "y post invalid: " + aGrid.roverPosition(rid).y.to_s + " rover: " + rid.to_s
    assert (aGrid.roverDirection(rid) == dir), "dir invalid" + " rover: " + rid.to_s
  end
end
