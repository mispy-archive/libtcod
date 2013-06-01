require_relative 'helpers'
require 'libtcod'
require 'minitest/autorun'

class TestConsole < Minitest::Test
  def setup
  end

  def test_create_game_window
    TCOD::Console.init_root(100, 100, "rah", false, :renderer_opengl)
  end
end
