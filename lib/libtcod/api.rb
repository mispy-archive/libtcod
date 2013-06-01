APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

module TCOD
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

    BackgroundFlag = enum(
      :bkgnd_none,
      :bkgnd_set,
      :bkgnd_multiply,
      :bkgnd_lighten,
      :bkgnd_darken,
      :bkgnd_screen,
      :bkgnd_color_dodge,
      :bkgnd_color_burn,
      :bkgnd_add,
      :bkgnd_adda,
      :bkgnd_burn,
      :bkgnd_overlay,
      :bkgnd_alph,
      :bkgnd_default
    )

    attach_function :console_init_root, 'TCOD_console_init_root', [:int, :int, :string, :bool, Renderer], :void
    attach_function :console_is_window_closed, 'TCOD_console_is_window_closed', [], :bool
    attach_function :console_new, 'TCOD_console_new', [:int, :int], :pointer
    attach_function :console_set_default_foreground, 'TCOD_console_set_default_foreground', [:pointer, Color.val], :void
    attach_function :console_put_char, 'TCOD_console_put_char', [:pointer, :int, :int, :int, BackgroundFlag], :void
    attach_function :console_flush, 'TCOD_console_flush', [], :void
  end
end
