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

    class Key < MethodStruct
      layout :vk, :int,
             :c, :uchar,
             :pressed, :bool,
             :lalt, :bool,
             :lctrl, :bool,
             :ralt, :bool,
             :rctrl, :bool,
             :shift, :bool
    end

    def self.tcod_function(sym, *args)
      attach_function(sym[5..-1].to_sym, sym, *args)
    end

    TCOD_renderer_t = :int
    TCOD_bkgnd_flag_t = :int
    TCOD_alignment_t = :int
    TCOD_keycode_t = :int
    TCOD_colctrl_t = :int

    tcod_function :TCOD_console_init_root, [ :int, :int, :string, :bool, TCOD_renderer_t ], :void
    tcod_function :TCOD_console_set_window_title, [ :string ], :void
    tcod_function :TCOD_console_set_fullscreen, [ :bool ], :void
    tcod_function :TCOD_console_is_fullscreen, [  ], :bool
    tcod_function :TCOD_console_is_window_closed, [  ], :bool
    tcod_function :TCOD_console_set_custom_font, [ :string, :int, :int, :int ], :void
    tcod_function :TCOD_console_map_ascii_code_to_font, [ :int, :int, :int ], :void
    tcod_function :TCOD_console_map_ascii_codes_to_font, [ :int, :int, :int, :int ], :void
    tcod_function :TCOD_console_map_string_to_font, [ :string, :int, :int ], :void
    tcod_function :TCOD_console_set_dirty, [ :int, :int, :int, :int ], :void
    tcod_function :TCOD_console_set_default_background, [ :pointer, Color.val ], :void
    tcod_function :TCOD_console_set_default_foreground, [ :pointer, Color.val ], :void
    tcod_function :TCOD_console_clear, [ :pointer ], :void
    tcod_function :TCOD_console_set_char_background, [ :pointer, :int, :int, Color.val, TCOD_bkgnd_flag_t ], :void
    tcod_function :TCOD_console_set_char_foreground, [ :pointer, :int, :int, Color.val ], :void
    tcod_function :TCOD_console_set_char, [ :pointer, :int, :int, :int ], :void
    tcod_function :TCOD_console_put_char, [ :pointer, :int, :int, :int, TCOD_bkgnd_flag_t ], :void
    tcod_function :TCOD_console_put_char_ex, [ :pointer, :int, :int, :int, Color.val, Color.val ], :void
    tcod_function :TCOD_console_set_background_flag, [ :pointer, TCOD_bkgnd_flag_t ], :void
    tcod_function :TCOD_console_get_background_flag, [ :pointer ], TCOD_bkgnd_flag_t
    tcod_function :TCOD_console_set_alignment, [ :pointer, TCOD_alignment_t ], :void
    tcod_function :TCOD_console_get_alignment, [ :pointer ], TCOD_alignment_t
    tcod_function :TCOD_console_print, [ :pointer, :int, :int, :string, :varargs ], :void
    tcod_function :TCOD_console_print_ex, [ :pointer, :int, :int, TCOD_bkgnd_flag_t, TCOD_alignment_t, :string, :varargs ], :void
    tcod_function :TCOD_console_print_rect, [ :pointer, :int, :int, :int, :int, :string, :varargs ], :int
    tcod_function :TCOD_console_print_rect_ex, [ :pointer, :int, :int, :int, :int, TCOD_bkgnd_flag_t, TCOD_alignment_t, :string, :varargs ], :int
    tcod_function :TCOD_console_get_height_rect, [ :pointer, :int, :int, :int, :int, :string, :varargs ], :int
    tcod_function :TCOD_console_rect, [ :pointer, :int, :int, :int, :int, :bool, TCOD_bkgnd_flag_t ], :void
    tcod_function :TCOD_console_hline, [ :pointer, :int, :int, :int, TCOD_bkgnd_flag_t ], :void
    tcod_function :TCOD_console_vline, [ :pointer, :int, :int, :int, TCOD_bkgnd_flag_t ], :void
    tcod_function :TCOD_console_print_frame, [ :pointer, :int, :int, :int, :int, :bool, TCOD_bkgnd_flag_t, :string, :varargs ], :void
    tcod_function :TCOD_console_map_string_to_font_utf, [ :pointer, :int, :int ], :void
    tcod_function :TCOD_console_print_utf, [ :pointer, :int, :int, :pointer, :varargs ], :void
    tcod_function :TCOD_console_print_ex_utf, [ :pointer, :int, :int, TCOD_bkgnd_flag_t, TCOD_alignment_t, :pointer, :varargs ], :void
    tcod_function :TCOD_console_print_rect_utf, [ :pointer, :int, :int, :int, :int, :pointer, :varargs ], :int
    tcod_function :TCOD_console_print_rect_ex_utf, [ :pointer, :int, :int, :int, :int, TCOD_bkgnd_flag_t, TCOD_alignment_t, :pointer, :varargs ], :int
    tcod_function :TCOD_console_get_height_rect_utf, [ :pointer, :int, :int, :int, :int, :pointer, :varargs ], :int
    tcod_function :TCOD_console_get_default_background, [ :pointer ], Color.val
    tcod_function :TCOD_console_get_default_foreground, [ :pointer ], Color.val
    tcod_function :TCOD_console_get_char_background, [ :pointer, :int, :int ], Color.val
    tcod_function :TCOD_console_get_char_foreground, [ :pointer, :int, :int ], Color.val
    tcod_function :TCOD_console_get_char, [ :pointer, :int, :int ], :int
    tcod_function :TCOD_console_set_fade, [ :uchar, Color.val ], :void
    tcod_function :TCOD_console_get_fade, [  ], :uchar
    tcod_function :TCOD_console_get_fading_color, [  ], Color.val
    tcod_function :TCOD_console_flush, [  ], :void
    tcod_function :TCOD_console_set_color_control, [ TCOD_colctrl_t, Color.val, Color.val ], :void
    tcod_function :TCOD_console_check_for_keypress, [ :int ], Key.val
    tcod_function :TCOD_console_wait_for_keypress, [ :bool ], Key.val
    tcod_function :TCOD_console_set_keyboard_repeat, [ :int, :int ], :void
    tcod_function :TCOD_console_disable_keyboard_repeat, [  ], :void
    tcod_function :TCOD_console_is_key_pressed, [ TCOD_keycode_t ], :bool
    tcod_function :TCOD_console_from_file, [ :string ], :pointer
    tcod_function :TCOD_console_load_asc, [ :pointer, :string ], :bool
    tcod_function :TCOD_console_load_apf, [ :pointer, :string ], :bool
    tcod_function :TCOD_console_save_asc, [ :pointer, :string ], :bool
    tcod_function :TCOD_console_save_apf, [ :pointer, :string ], :bool
    tcod_function :TCOD_console_new, [ :int, :int ], :pointer
    tcod_function :TCOD_console_get_width, [ :pointer ], :int
    tcod_function :TCOD_console_get_height, [ :pointer ], :int
    tcod_function :TCOD_console_set_key_color, [ :pointer, Color.val ], :void
    tcod_function :TCOD_console_blit, [ :pointer, :int, :int, :int, :int, :pointer, :int, :int, :float, :float ], :void
    tcod_function :TCOD_console_delete, [ :pointer ], :void
    tcod_function :TCOD_console_credits, [  ], :void
    tcod_function :TCOD_console_credits_reset, [  ], :void
    tcod_function :TCOD_console_credits_render, [ :int, :int, :bool ], :bool
  end
end
