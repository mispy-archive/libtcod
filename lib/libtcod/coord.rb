module TCOD
  class Coord
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def ==(other)
      @x == other.x && @y == other.y
    end

    def +(other)
      Coord.new(@x + other.x, @y + other.y)
    end

    def -(other)
      Coord.new(@x - other.x, @y - other.y)
    end

    def to_s
      "p(#{x}, #{y})"
    end

    def to_a
      [x, y]
    end
  end
end
