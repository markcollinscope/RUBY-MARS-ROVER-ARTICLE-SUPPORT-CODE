require 'parser'
require 'grid'

def main
  if ARGV.length != 1
    usage()
  end
  doParse(ARGV[0])
  exit(0)
end

def usage()
  puts "Usage: #{$0} filename"
  exit(1)
end

OUTPUTDIRECTIONS = Hash[
  :north => "N",
  :south => "S",
  :east => "E",
  :west => "W"
]
def doParse(file)
  begin
    aParser = Parser::Parser.new()
    aGrid = aParser.parseMarsControlFile(file)
    for rid in aGrid.rovers do
    puts     aGrid.roverPosition(rid).x.to_s + 
              " " + aGrid.roverPosition(rid).y.to_s + 
              " " + OUTPUTDIRECTIONS[aGrid.roverDirection(rid)]
    end
  rescue Parser::SyntaxError => se
    puts se.message + " " + "Line: " + se.lineNum.to_s + " of file: " + file
  rescue MarsGrid::GridError => gbe
    puts gbe.message + " - roverid: " + gbe.roverId.to_s + " xpos: " + gbe.x.to_s + " xpos: " + gbe.x.to_s
  end
end

# do it!
main