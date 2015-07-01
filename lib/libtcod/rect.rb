module TCOD
  class Rect
    attr_reader :position, :width, :height

    def initialize(position, width, height)
      if width < 1
        fail ArgumentError,
             "ArgumentError: Rect width must be strictly positive (#{width})"
      elsif height < 1
        fail ArgumentError,
             "ArgumentError: Rect height must be strictly positive (#{height})"
      end

      @position = position
      @width = width
      @height = height
    end

    def left
      @position.x
    end

    def right
      @position.x + width - 1
    end

    def top
      @position.y
    end

    def bottom
      @position.y + height - 1
    end

    def center
      [(right - left) / 2, (bottom - top) / 2]
    end

    def x_range
      left..right
    end

    def y_range
      top..bottom
    end

    def include?(coord)
      x_range.include?(coord.x) && y_range.include?(coord.y)
    end

    def ==(other)
      @position == other.position &&
        @width == other.width &&
        @height == other.height
    end
  end
end
