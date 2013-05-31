require 'ffi'
require 'libtcod/version'

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

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

  # Raw C function bindings
  module C
    extend FFI::Library
    ffi_lib File.join(APP_ROOT, "libtcod-1.5.1/libtcod.so")

    # Colors
    attach_function :color_RGB, 'TCOD_color_RGB', [:uchar, :uchar, :uchar], Color.val
    attach_function :color_HSV, 'TCOD_color_HSV', [:float, :float, :float], Color.val
    attach_function :color_equals, 'TCOD_color_equals', [Color.val, Color.val], :bool
    attach_function :color_multiply, 'TCOD_color_multiply', [Color.val, Color.val], Color.val
    attach_function :color_multiply_scalar, 'TCOD_color_multiply_scalar', [Color.val, :float], Color.val

    # Console
    Renderer = enum(
      :renderer_glsl,
      :renderer_opengl,
      :renderer_sdl,
      :nb_renderers
    )

    attach_function :console_init_root, 'TCOD_console_init_root', [:int, :int, :string, :bool, Renderer], :void
  end
end
