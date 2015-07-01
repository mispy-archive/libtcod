module TCOD
  class Cell
    attr_reader :glyph, :fore_color, :back_color

    def initialize(glyph, fore_color, back_color)
      @glyph = glyph.ord
      @fore_color = fore_color
      @back_color = back_color
    end

    def ==(other)
      other.glyph == @glyph &&
        other.fore_color == @fore_color &&
        other.back_color == @back_color
    end
  end
end
