require_relative 'helpers'
require 'libtcod'
require 'minitest/autorun'

class TestColor < Minitest::Test
  def setup
    @c1 = TCOD::Color.rgb(255,0,1)
    @c2 = TCOD::Color.rgb(100,4,58)
  end

  def test_create_colors
    c = TCOD::Color.rgb(5,5,5)
    c2 = TCOD::Color.hsv(5,5,5)
  end
  
  def test_compare_colors
    c1 = TCOD::Color.rgb(2, 4, 8)
    c2 = TCOD::Color.rgb(2, 4, 8)
    c3 = TCOD::Color.rgb(8, 16, 32)
    assert_equal c1, c2
    refute_equal c1, c3
  end

  def test_multiply_colors
    c1 = TCOD::Color.rgb(55,100,250)
    c2 = TCOD::Color.rgb(70, 130, 224)
    c3 = c1 * c2
    assert_equal c3, TCOD::Color.rgb(15, 50, 219)
  end

  def test_multiply_colors_float
    c1 = TCOD::Color.rgb(55,100,250)
    c2 = c1*2
    assert_equal c2, TCOD::Color.rgb(110, 200, 255)
  end

  def test_adding_colors
  end
end
