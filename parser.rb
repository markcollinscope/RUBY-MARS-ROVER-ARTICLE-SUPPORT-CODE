require 'grid'
require 'pair'

module Parser
  class SyntaxError < RuntimeError; 
      attr_reader :lineNum
      def initialize(lineNum)
        @lineNum = lineNum
      end
  end
  class FileError < RuntimeError; end

  class Parser
    def initialise
      @lines = Array.new
    end

    def readFile(filename)
      begin
        @lines = File.readlines(filename)
      rescue
        raise FileError.new, "No such file: " + filename
      end
    end
    
    def nLines
      return @lines.length
    end
    
    def setUpTestData(arr)
      @lines = arr
    end
    
    TWONUMMATCH = /(\d+)\W(\d+)/
    def parseGridSize(line,lineNum)
      m = TWONUMMATCH.match(line)
      if (m == nil)
        raise SyntaxError.new(lineNum), "Invalid Grid Size Information: " + line
      else
        return MarsGrid::Grid.new(
          Pair.new(m[1].to_i+1,m[2].to_i+1)
        )
      end
    end
    
    DIRECTIONS = Hash[
      "N" => :north,
      "S" => :south,
      "E" => :east,
      "W" => :west
    ]
    ROVERSTARTLINE = /(\d+)\W(\d+)\W([NSEW])/
    def parseRoverStartLine(grid,line,lineNum)
      m = ROVERSTARTLINE.match(line)
      if (m == nil)
        raise SyntaxError.new(lineNum), "Invalid Rover Start Information: " + line
      else
        return grid.addRover(Pair.new(m[1].to_i,m[2].to_i),DIRECTIONS[m[3]])
      end
    end

    def parseCommandLine(aGrid, rid, line, lineNum)
      for i in 0 ... line.length do
      s = line[i..i]
      case s
        when /L/ : aGrid.turnRover(rid, :left)
        when /R/ : aGrid.turnRover(rid, :right)
        when /M/ : aGrid.moveRover(rid)
        when /\n/: 
        else
          raise SyntaxError.new(lineNum), "Input CMD is " + s
        end
      end
    end
    
    def parseMarsControlFile(file)
      readFile(file)
      linePos = 0
      if ((@lines.length % 2) != 1)
        raise SyntaxError.new(linePos), "Incorrect number of lines in input file" 
      end
      aGrid = parseGridSize(@lines[linePos],linePos+1)
      linePos += 1
      while (linePos < @lines.length)
        rid = parseRoverStartLine(aGrid,@lines[linePos],linePos+1)
        linePos += 1
        parseCommandLine(aGrid,rid,@lines[linePos],linePos+1)
        linePos += 1

      end
      return aGrid
    end
  end
end