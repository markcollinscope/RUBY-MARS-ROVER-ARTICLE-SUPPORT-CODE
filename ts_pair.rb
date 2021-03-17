require 'test/unit'
require 'pair'

class TestPair < Test::Unit::TestCase

  XSTART, YSTART = 100, 33
  def testEquals
      assert(Pair.new(XSTART,YSTART) == Pair.new(XSTART,YSTART))
  end
    
  XADD, YADD = 400, 21
  def testPlusEquals
     p = Pair.new(XSTART,YSTART)
     addBit = Pair.new(XADD,YADD)
     p += addBit
     assert_equal(p.x, XSTART + XADD)
     assert_equal(p.y, YSTART + YADD)
   end
end
