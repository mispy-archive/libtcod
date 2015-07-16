module TCOD
  class Color < MethodStruct
    layout :r, :uchar,
           :g, :uchar,
           :b, :uchar

    def self.rgb(red, green, blue)
      TCOD.color_RGB(clamp(0, red, 255),
                     clamp(0, green, 255),
                     clamp(0, blue, 255))
    end

    def self.hsv(h,s,v)
      TCOD.color_HSV(h,s,v)
    end

    def self.clamp(lower_bound, color_component, upper_bound)
      [lower_bound, [color_component, upper_bound].min].max
    end

    def ==(col)
      TCOD.color_equals(self, col)
    end

    def +(other)
      Color.rgb(red + other.red, green + other.green, blue + other.blue)
    end

    def -(other)
      Color.rgb(red - other.red, green - other.green, blue - other.blue)
    end

    def *(col_or_float)
      if col_or_float.is_a? Color
        TCOD.color_multiply(self, col_or_float)
      else
        TCOD.color_multiply_scalar(self, col_or_float)
      end
    end

    def to_s
      "<Color #{red}, #{green}, #{blue}>"
    end

    def to_a
      [red, green, blue]
    end

    def red=(new_red)
      self[:r] = Color.clamp(0, new_red, 255)
    end

    def green=(new_green)
      self[:g] = Color.clamp(0, new_green, 255)
    end

    def blue=(new_blue)
      self[:b] = Color.clamp(0, new_blue, 255)
    end

    def hue
      TCOD.color_get_hue(self)
    end

    def hue=(new_hue)
      TCOD.color_set_hue(self, new_hue)
    end

    def value
      TCOD.color_get_value(self)
    end

    def value=(new_value)
      TCOD.color_set_value(self, new_value)
    end

    def saturation
      TCOD.color_get_saturation
    end

    def saturation=(new_saturation)
      TCOD.color_set_saturation(self, new_saturation)
    end

    alias_method :red, :r
    alias_method :green, :g
    alias_method :blue, :b
    alias_method :r=, :red=
    alias_method :g=, :green=
    alias_method :b=, :blue=

    alias_method :h, :hue
    alias_method :s, :saturation
    alias_method :v, :value
    alias_method :h=, :hue=
    alias_method :s=, :saturation=
    alias_method :v=, :value=
  end
end
