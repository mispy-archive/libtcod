module TCOD
  class Color < FFI::Struct
    layout :r, :uchar,
           :g, :uchar,
           :b, :uchar

    def self.rgb(r,g,b)
      C.color_RGB(r,g,b)
    end

    def self.hsv(h,s,v)
      C.color_HSV(h,s,v)
    end

    def ==(col)
      C.color_equals(self, col)
    end

    def *(col_or_float)
      if col_or_float.is_a? Color
        C.color_multiply(self, col_or_float)
      else
        C.color_multiply_scalar(self, col_or_float)
      end
    end

    def to_s
      "<Color #{self[:r]}, #{self[:g]}, #{self[:b]}>"
    end
  end
end
