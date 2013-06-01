APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

module TCOD
  extend FFI::Library

  if RUBY_PLATFORM.include?('x86_64')
    ffi_lib ['libtcod', File.join(APP_ROOT, "clib/amd64/libtcod.so")]
  else
    ffi_lib ['libtcod', File.join(APP_ROOT, "clib/i686/libtcod.so")]
  end

  # Remove redundant namespacing
  def self.tcod_function(sym, *args)
    attach_function(sym[5..-1].to_sym, sym, *args)
  end

  ### Color module
  class Color < FFI::Struct
    layout :r, :uchar,
           :g, :uchar,
           :b, :uchar

    def self.rgb(r,g,b)
      TCOD.color_RGB(r,g,b)
    end

    def self.hsv(h,s,v)
      TCOD.color_HSV(h,s,v)
    end

    def ==(col)
      TCOD.color_equals(self, col)
    end

    def *(col_or_float)
      if col_or_float.is_a? Color
        TCOD.color_multiply(self, col_or_float)
      else
        TCOD.color_multiply_scalar(self, col_or_float)
      end
    end

    def to_s
      "<Color #{self[:r]}, #{self[:g]}, #{self[:b]}>"
    end
  end

  tcod_function :TCOD_color_RGB, [ :uchar, :uchar, :uchar ], Color.val
  tcod_function :TCOD_color_HSV, [ :float, :float, :float ], Color.val
  tcod_function :TCOD_color_equals, [ Color.val, Color.val ], :bool
  tcod_function :TCOD_color_add, [ Color.val, Color.val ], Color.val
  tcod_function :TCOD_color_subtract, [ Color.val, Color.val ], Color.val
  tcod_function :TCOD_color_multiply, [ Color.val, Color.val ], Color.val
  tcod_function :TCOD_color_multiply_scalar, [ Color.val, :float ], Color.val
  tcod_function :TCOD_color_lerp, [ Color.val, Color.val, :float ], Color.val
  tcod_function :TCOD_color_set_HSV, [ :pointer, :float, :float, :float ], :void
  tcod_function :TCOD_color_get_HSV, [ Color.val, :pointer, :pointer, :pointer ], :void
  tcod_function :TCOD_color_get_hue, [ Color.val ], :float
  tcod_function :TCOD_color_set_hue, [ :pointer, :float ], :void
  tcod_function :TCOD_color_get_saturation, [ Color.val ], :float
  tcod_function :TCOD_color_set_saturation, [ :pointer, :float ], :void
  tcod_function :TCOD_color_get_value, [ Color.val ], :float
  tcod_function :TCOD_color_set_value, [ :pointer, :float ], :void
  tcod_function :TCOD_color_shift_hue, [ :pointer, :float ], :void
  tcod_function :TCOD_color_scale_HSV, [ :pointer, :float, :float ], :void
  tcod_function :TCOD_color_gen_map, [ :pointer, :int, :pointer, :pointer ], :void

  ### Console module
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

  TCOD_renderer_t = :int
  TCOD_bkgnd_flag_t = :int
  TCOD_alignment_t = :int
  TCOD_keycode_t = :int
  TCOD_colctrl_t = :int
  TCOD_console_t = :pointer

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

  ### System module
  EVENT_KEY_PRESS = 1
  EVENT_MOUSE_RELEASE = 16
  EVENT_KEY_RELEASE = 2
  EVENT_MOUSE_MOVE = 4
  EVENT_MOUSE_PRESS = 8
  EVENT_MOUSE = EVENT_MOUSE_MOVE|EVENT_MOUSE_PRESS|EVENT_MOUSE_RELEASE
  EVENT_KEY = EVENT_KEY_PRESS|EVENT_KEY_RELEASE
  EVENT_ANY = EVENT_KEY|EVENT_MOUSE

  TCOD_image_t = :pointer
  TCOD_list_t = :pointer

  tcod_function :TCOD_sys_elapsed_milli, [  ], :uint32
  tcod_function :TCOD_sys_elapsed_seconds, [  ], :float
  tcod_function :TCOD_sys_sleep_milli, [ :uint32 ], :void
  tcod_function :TCOD_sys_save_screenshot, [ :string ], :void
  tcod_function :TCOD_sys_force_fullscreen_resolution, [ :int, :int ], :void
  tcod_function :TCOD_sys_set_renderer, [ TCOD_renderer_t ], :void
  tcod_function :TCOD_sys_get_renderer, [  ], TCOD_renderer_t
  tcod_function :TCOD_sys_set_fps, [ :int ], :void
  tcod_function :TCOD_sys_get_fps, [  ], :int
  tcod_function :TCOD_sys_get_last_frame_length, [  ], :float
  tcod_function :TCOD_sys_get_current_resolution, [ :pointer, :pointer ], :void
  tcod_function :TCOD_sys_get_fullscreen_offsets, [ :pointer, :pointer ], :void
  tcod_function :TCOD_sys_update_char, [ :int, :int, :int, TCOD_image_t, :int, :int ], :void
  tcod_function :TCOD_sys_get_char_size, [ :pointer, :pointer ], :void
  #tcod_function :TCOD_sys_get_sdl_window, [  ], :pointer

  tcod_function :TCOD_sys_wait_for_event, [ :int, :pointer, :pointer, :bool ], :int
  tcod_function :TCOD_sys_check_for_event, [ :int, :pointer, :pointer ], :int
  tcod_function :TCOD_sys_create_directory, [ :string ], :bool
  tcod_function :TCOD_sys_delete_file, [ :string ], :bool
  tcod_function :TCOD_sys_delete_directory, [ :string ], :bool
  tcod_function :TCOD_sys_is_directory, [ :string ], :bool
  tcod_function :TCOD_sys_get_directory_content, [ :string, :string ], TCOD_list_t
  tcod_function :TCOD_sys_file_exists, [ :string, :varargs ], :bool
  tcod_function :TCOD_sys_read_file, [ :string, :pointer, :pointer ], :bool
  tcod_function :TCOD_sys_write_file, [ :string, :pointer, :uint32 ], :bool
  tcod_function :TCOD_sys_clipboard_set, [ :string ], :void
  tcod_function :TCOD_sys_clipboard_get, [  ], :string
  tcod_function :TCOD_thread_new, [ callback([ :pointer ], :int), :pointer ], :pointer
  tcod_function :TCOD_thread_delete, [ :pointer ], :void
  tcod_function :TCOD_sys_get_num_cores, [  ], :int
  tcod_function :TCOD_thread_wait, [ :pointer ], :void
  tcod_function :TCOD_mutex_new, [  ], :pointer
  tcod_function :TCOD_mutex_in, [ :pointer ], :void
  tcod_function :TCOD_mutex_out, [ :pointer ], :void
  tcod_function :TCOD_mutex_delete, [ :pointer ], :void
  tcod_function :TCOD_semaphore_new, [ :int ], :pointer
  tcod_function :TCOD_semaphore_lock, [ :pointer ], :void
  tcod_function :TCOD_semaphore_unlock, [ :pointer ], :void
  tcod_function :TCOD_semaphore_delete, [ :pointer ], :void
  tcod_function :TCOD_condition_new, [  ], :pointer
  tcod_function :TCOD_condition_signal, [ :pointer ], :void
  tcod_function :TCOD_condition_broadcast, [ :pointer ], :void
  tcod_function :TCOD_condition_wait, [ :pointer, :pointer ], :void
  tcod_function :TCOD_condition_delete, [ :pointer ], :void
  tcod_function :TCOD_load_library, [ :string ], :pointer
  tcod_function :TCOD_get_function_address, [ :pointer, :string ], :pointer
  tcod_function :TCOD_close_library, [ :pointer ], :void
  callback(:SDL_renderer_t, [ :pointer ], :void)
  tcod_function :TCOD_sys_register_SDL_renderer, [ :SDL_renderer_t ], :void

  ### Line module
  class BresenhamData < MethodStruct
    layout(
           :stepx, :int,
           :stepy, :int,
           :e, :int,
           :deltax, :int,
           :deltay, :int,
           :origx, :int,
           :origy, :int,
           :destx, :int,
           :desty, :int
    )
  end
  callback(:TCOD_line_listener_t, [ :int, :int ], :bool)
  tcod_function :TCOD_line_init, [ :int, :int, :int, :int ], :void
  tcod_function :TCOD_line_step, [ :pointer, :pointer ], :bool
  tcod_function :TCOD_line, [ :int, :int, :int, :int, :TCOD_line_listener_t ], :bool
  tcod_function :TCOD_line_init_mt, [ :int, :int, :int, :int, :pointer ], :void
  tcod_function :TCOD_line_step_mt, [ :pointer, :pointer, :pointer ], :bool
  tcod_function :TCOD_line_mt, [ :int, :int, :int, :int, :TCOD_line_listener_t, :pointer ], :bool

  ### Image module
  tcod_function :TCOD_image_new, [ :int, :int ], :pointer
  tcod_function :TCOD_image_from_console, [ TCOD_console_t ], :pointer
  tcod_function :TCOD_image_refresh_console, [ :pointer, TCOD_console_t ], :void
  tcod_function :TCOD_image_load, [ :string ], :pointer
  tcod_function :TCOD_image_clear, [ :pointer, Color.val ], :void
  tcod_function :TCOD_image_invert, [ :pointer ], :void
  tcod_function :TCOD_image_hflip, [ :pointer ], :void
  tcod_function :TCOD_image_rotate90, [ :pointer, :int ], :void
  tcod_function :TCOD_image_vflip, [ :pointer ], :void
  tcod_function :TCOD_image_scale, [ :pointer, :int, :int ], :void
  tcod_function :TCOD_image_save, [ :pointer, :string ], :void
  tcod_function :TCOD_image_get_size, [ :pointer, :pointer, :pointer ], :void
  tcod_function :TCOD_image_get_pixel, [ :pointer, :int, :int ], Color.val
  tcod_function :TCOD_image_get_alpha, [ :pointer, :int, :int ], :int
  tcod_function :TCOD_image_get_mipmap_pixel, [ :pointer, :float, :float, :float, :float ], Color.val
  tcod_function :TCOD_image_put_pixel, [ :pointer, :int, :int, Color.val ], :void
  tcod_function :TCOD_image_blit, [ :pointer, TCOD_console_t, :float, :float, TCOD_bkgnd_flag_t, :float, :float, :float ], :void
  tcod_function :TCOD_image_blit_rect, [ :pointer, TCOD_console_t, :int, :int, :int, :int, TCOD_bkgnd_flag_t ], :void
  tcod_function :TCOD_image_blit_2x, [ :pointer, TCOD_console_t, :int, :int, :int, :int, :int, :int ], :void
  tcod_function :TCOD_image_delete, [ :pointer ], :void
  tcod_function :TCOD_image_set_key_color, [ :pointer, Color.val ], :void
  tcod_function :TCOD_image_is_pixel_transparent, [ :pointer, :int, :int ], :bool

  ### Mouse module
  class MouseStatus < MethodStruct
    layout(
           :x, :int,
           :y, :int,
           :dx, :int,
           :dy, :int,
           :cx, :int,
           :cy, :int,
           :dcx, :int,
           :dcy, :int,
           :lbutton, :bool,
           :rbutton, :bool,
           :mbutton, :bool,
           :lbutton_pressed, :bool,
           :rbutton_pressed, :bool,
           :mbutton_pressed, :bool,
           :wheel_up, :bool,
           :wheel_down, :bool
    )
  end
  attach_function :TCOD_mouse_show_cursor, [ :bool ], :void
  attach_function :TCOD_mouse_get_status, [  ], MouseStatus
  attach_function :TCOD_mouse_is_cursor_visible, [  ], :bool
  attach_function :TCOD_mouse_move, [ :int, :int ], :void
  #attach_function :TCOD_mouse_includes_touch, [ :bool ], :void

  ### Parser module
  TYPE_NONE = 0
  TYPE_BOOL = 1
  TYPE_VALUELIST02 = 10
  TYPE_LIST = 1024
  TYPE_VALUELIST03 = 11
  TYPE_VALUELIST04 = 12
  TYPE_VALUELIST05 = 13
  TYPE_VALUELIST06 = 14
  TYPE_VALUELIST07 = 15
  TYPE_VALUELIST08 = 16
  TYPE_VALUELIST09 = 17
  TYPE_VALUELIST10 = 18
  TYPE_VALUELIST11 = 19
  TYPE_CHAR = 2
  TYPE_VALUELIST12 = 20
  TYPE_VALUELIST13 = 21
  TYPE_VALUELIST14 = 22
  TYPE_VALUELIST15 = 23
  TYPE_CUSTOM00 = 24
  TYPE_CUSTOM01 = 25
  TYPE_CUSTOM02 = 26
  TYPE_CUSTOM03 = 27
  TYPE_CUSTOM04 = 28
  TYPE_CUSTOM05 = 29
  TYPE_INT = 3
  TYPE_CUSTOM06 = 30
  TYPE_CUSTOM07 = 31
  TYPE_CUSTOM08 = 32
  TYPE_CUSTOM09 = 33
  TYPE_CUSTOM10 = 34
  TYPE_CUSTOM11 = 35
  TYPE_CUSTOM12 = 36
  TYPE_CUSTOM13 = 37
  TYPE_CUSTOM14 = 38
  TYPE_CUSTOM15 = 39
  TYPE_FLOAT = 4
  TYPE_STRING = 5
  TYPE_COLOR = 6
  TYPE_DICE = 7
  TYPE_VALUELIST00 = 8
  TYPE_VALUELIST01 = 9

  class Dice < MethodStruct
    layout(
       :nb_rolls, :int,
       :nb_faces, :int,
       :multiplier, :float,
       :addsub, :float
    )
  end

  class TCODValueT < MethodUnion
    layout(
           :b, :bool,
           :c, :char,
           :i, :int32,
           :f, :float,
           :s, :pointer,
           :col, Color,
           :dice, Dice,
           :list, TCOD_list_t,
           :custom, :pointer
    )
    def s=(str)
      @s = FFI::MemoryPointer.from_string(str)
      self[:s] = @s
    end
    def s
      @s.get_string(0)
    end
  end

  class TCODStructIntT < MethodStruct
    layout(
           :name, :pointer,
           :flags, TCOD_list_t,
           :props, TCOD_list_t,
           :lists, TCOD_list_t,
           :structs, TCOD_list_t
    )
    def name=(str)
      @name = FFI::MemoryPointer.from_string(str)
      self[:name] = @name
    end
    def name
      @name.get_string(0)
    end
  end

  callback(:TCOD_parser_custom_t, [ :pointer, :pointer, :pointer, :string ], TCODValueT.val)
  class TCODParserIntT < MethodStruct
    layout(
           :structs, TCOD_list_t,
           :customs, [:TCOD_parser_custom_t, 16],
           :fatal, :bool,
           :props, TCOD_list_t
    )
  end

  class TCODParserListenerT < MethodStruct
    layout(
           :new_struct, callback([ :pointer, :string ], :bool),
           :new_flag, callback([ :string ], :bool),
           :new_property, callback([ :string, :int, TCODValueT ], :bool),
           :end_struct, callback([ :pointer, :string ], :bool),
           :error, callback([ :string ], :void)
    )
  end

  tcod_function :TCOD_struct_get_name, [ :pointer ], :string
  tcod_function :TCOD_struct_add_property, [ :pointer, :string, :int, :bool ], :void
  tcod_function :TCOD_struct_add_list_property, [ :pointer, :string, :int, :bool ], :void
  tcod_function :TCOD_struct_add_value_list, [ :pointer, :string, :pointer, :bool ], :void
  tcod_function :TCOD_struct_add_value_list_sized, [ :pointer, :string, :pointer, :int, :bool ], :void
  tcod_function :TCOD_struct_add_flag, [ :pointer, :string ], :void
  tcod_function :TCOD_struct_add_structure, [ :pointer, :pointer ], :void
  tcod_function :TCOD_struct_is_mandatory, [ :pointer, :string ], :bool
  tcod_function :TCOD_struct_get_type, [ :pointer, :string ], :int

  tcod_function :TCOD_parser_new, [  ], :pointer
  tcod_function :TCOD_parser_new_struct, [ :pointer, :string ], :pointer
  tcod_function :TCOD_parser_new_custom_type, [ :pointer, :TCOD_parser_custom_t ], :int
  tcod_function :TCOD_parser_run, [ :pointer, :string, :pointer ], :void
  tcod_function :TCOD_parser_delete, [ :pointer ], :void
  tcod_function :TCOD_parser_error, [ :string, :varargs ], :void
  tcod_function :TCOD_parser_get_bool_property, [ :pointer, :string ], :bool
  tcod_function :TCOD_parser_get_char_property, [ :pointer, :string ], :int
  tcod_function :TCOD_parser_get_int_property, [ :pointer, :string ], :int
  tcod_function :TCOD_parser_get_float_property, [ :pointer, :string ], :float
  tcod_function :TCOD_parser_get_string_property, [ :pointer, :string ], :string
  tcod_function :TCOD_parser_get_color_property, [ :pointer, :string ], Color.val
  tcod_function :TCOD_parser_get_dice_property, [ :pointer, :string ], Dice.val
  tcod_function :TCOD_parser_get_dice_property_py, [ :pointer, :string, :pointer ], :void
  tcod_function :TCOD_parser_get_custom_property, [ :pointer, :string ], :pointer
  tcod_function :TCOD_parser_get_list_property, [ :pointer, :string, :int ], TCOD_list_t

  tcod_function :TCOD_parse_bool_value, [  ], TCODValueT
  tcod_function :TCOD_parse_char_value, [  ], TCODValueT
  tcod_function :TCOD_parse_integer_value, [  ], TCODValueT
  tcod_function :TCOD_parse_float_value, [  ], TCODValueT
  tcod_function :TCOD_parse_string_value, [  ], TCODValueT
  tcod_function :TCOD_parse_color_value, [  ], TCODValueT
  tcod_function :TCOD_parse_dice_value, [  ], TCODValueT
  tcod_function :TCOD_parse_value_list_value, [ :pointer, :int ], TCODValueT
  tcod_function :TCOD_parse_property_value, [ :pointer, :pointer, :string, :bool ], TCODValueT

  ### Random module
  RNG_MT = 0
  RNG_CMWC = 1

  DISTRIBUTION_LINEAR = 0
  DISTRIBUTION_GAUSSIAN = 1
  DISTRIBUTION_GAUSSIAN_RANGE = 2
  DISTRIBUTION_GAUSSIAN_INVERSE = 3
  DISTRIBUTION_GAUSSIAN_RANGE_INVERSE = 4

  TCOD_random_algo_t = :int
  TCOD_distribution_t = :int
  TCOD_random_t = :pointer

  tcod_function :TCOD_random_get_instance, [  ], :pointer
  tcod_function :TCOD_random_new, [ TCOD_random_algo_t ], :pointer
  tcod_function :TCOD_random_save, [ :pointer ], :pointer
  tcod_function :TCOD_random_restore, [ :pointer, :pointer ], :void
  tcod_function :TCOD_random_new_from_seed, [ TCOD_random_algo_t, :uint32 ], :pointer
  tcod_function :TCOD_random_delete, [ :pointer ], :void
  tcod_function :TCOD_random_set_distribution, [ :pointer, TCOD_distribution_t ], :void
  tcod_function :TCOD_random_get_int, [ :pointer, :int, :int ], :int
  tcod_function :TCOD_random_get_float, [ :pointer, :float, :float ], :float
  tcod_function :TCOD_random_get_double, [ :pointer, :double, :double ], :double
  tcod_function :TCOD_random_get_int_mean, [ :pointer, :int, :int, :int ], :int
  tcod_function :TCOD_random_get_float_mean, [ :pointer, :float, :float, :float ], :float
  tcod_function :TCOD_random_get_double_mean, [ :pointer, :double, :double, :double ], :double
  tcod_function :TCOD_random_dice_new, [ :string ], Dice.val
  tcod_function :TCOD_random_dice_roll, [ :pointer, Dice.val ], :int
  tcod_function :TCOD_random_dice_roll_s, [ :pointer, :string ], :int

  ### Noise module
  NOISE_DEFAULT_HURST = 0.5
  NOISE_DEFAULT_LACUNARITY = 2.0

  NOISE_DEFAULT = 0
  NOISE_PERLIN = 1
  NOISE_SIMPLEX = 2
  NOISE_WAVELET = 4

  tcod_function :TCOD_noise_new, [ :int, :float, :float, TCOD_random_t ], :pointer
  tcod_function :TCOD_noise_set_type, [ :pointer, :int ], :void
  tcod_function :TCOD_noise_get_ex, [ :pointer, :pointer, :int ], :float
  tcod_function :TCOD_noise_get_fbm_ex, [ :pointer, :pointer, :float, :int ], :float
  tcod_function :TCOD_noise_get_turbulence_ex, [ :pointer, :pointer, :float, :int ], :float
  tcod_function :TCOD_noise_get, [ :pointer, :pointer ], :float
  tcod_function :TCOD_noise_get_fbm, [ :pointer, :pointer, :float ], :float
  tcod_function :TCOD_noise_get_turbulence, [ :pointer, :pointer, :float ], :float
  tcod_function :TCOD_noise_delete, [ :pointer ], :void

  ### FOV module
  FOV_BASIC = 0
  FOV_DIAMOND = 1
  FOV_SHADOW = 2
  FOV_PERMISSIVE_0 = 3
  FOV_PERMISSIVE_1 = 4
  FOV_PERMISSIVE_2 = 5
  FOV_PERMISSIVE_3 = 6
  FOV_PERMISSIVE_4 = 7
  FOV_PERMISSIVE_5 = 8
  FOV_PERMISSIVE_6 = 9
  FOV_PERMISSIVE_7 = 10
  FOV_PERMISSIVE_8 = 11
  FOV_RESTRICTIVE = 12
  NB_FOV_ALGORITHMS = 13

  TCOD_fov_algorithm_t = :int

  tcod_function :TCOD_map_new, [ :int, :int ], :pointer
  tcod_function :TCOD_map_clear, [ :pointer, :bool, :bool ], :void
  tcod_function :TCOD_map_copy, [ :pointer, :pointer ], :void
  tcod_function :TCOD_map_set_properties, [ :pointer, :int, :int, :bool, :bool ], :void
  tcod_function :TCOD_map_delete, [ :pointer ], :void
  tcod_function :TCOD_map_compute_fov, [ :pointer, :int, :int, :int, :bool, TCOD_fov_algorithm_t ], :void
  tcod_function :TCOD_map_is_in_fov, [ :pointer, :int, :int ], :bool
  tcod_function :TCOD_map_set_in_fov, [ :pointer, :int, :int, :bool ], :void
  tcod_function :TCOD_map_is_transparent, [ :pointer, :int, :int ], :bool
  tcod_function :TCOD_map_is_walkable, [ :pointer, :int, :int ], :bool
  tcod_function :TCOD_map_get_width, [ :pointer ], :int
  tcod_function :TCOD_map_get_height, [ :pointer ], :int
  tcod_function :TCOD_map_get_nb_cells, [ :pointer ], :int

  ### Pathfinding module
  TCOD_map_t = :pointer

  callback(:TCOD_path_func_t, [ :int, :int, :int, :int, :pointer ], :float)
  tcod_function :TCOD_path_new_using_map, [ TCOD_map_t, :float ], :pointer
  tcod_function :TCOD_path_new_using_function, [ :int, :int, :TCOD_path_func_t, :pointer, :float ], :pointer
  tcod_function :TCOD_path_compute, [ :pointer, :int, :int, :int, :int ], :bool
  tcod_function :TCOD_path_walk, [ :pointer, :pointer, :pointer, :bool ], :bool
  tcod_function :TCOD_path_is_empty, [ :pointer ], :bool
  tcod_function :TCOD_path_size, [ :pointer ], :int
  tcod_function :TCOD_path_reverse, [ :pointer ], :void
  tcod_function :TCOD_path_get, [ :pointer, :int, :pointer, :pointer ], :void
  tcod_function :TCOD_path_get_origin, [ :pointer, :pointer, :pointer ], :void
  tcod_function :TCOD_path_get_destination, [ :pointer, :pointer, :pointer ], :void
  tcod_function :TCOD_path_delete, [ :pointer ], :void
  tcod_function :TCOD_dijkstra_new, [ TCOD_map_t, :float ], :pointer
  tcod_function :TCOD_dijkstra_new_using_function, [ :int, :int, :TCOD_path_func_t, :pointer, :float ], :pointer
  tcod_function :TCOD_dijkstra_compute, [ :pointer, :int, :int ], :void
  tcod_function :TCOD_dijkstra_get_distance, [ :pointer, :int, :int ], :float
  tcod_function :TCOD_dijkstra_path_set, [ :pointer, :int, :int ], :bool
  tcod_function :TCOD_dijkstra_is_empty, [ :pointer ], :bool
  tcod_function :TCOD_dijkstra_size, [ :pointer ], :int
  tcod_function :TCOD_dijkstra_reverse, [ :pointer ], :void
  tcod_function :TCOD_dijkstra_get, [ :pointer, :int, :pointer, :pointer ], :void
  tcod_function :TCOD_dijkstra_path_walk, [ :pointer, :pointer, :pointer ], :bool
  tcod_function :TCOD_dijkstra_delete, [ :pointer ], :void

  ### BSP module
  class TCODTreeT < FFI::Struct
    layout(
           :next, :pointer,
           :father, :pointer,
           :sons, :pointer
    )
  end
  tcod_function :TCOD_tree_new, [  ], :pointer
  tcod_function :TCOD_tree_add_son, [ :pointer, :pointer ], :void


  class TCODBspT < MethodStruct
    layout(
       :tree, TCODTreeT,
       :x, :int,
       :y, :int,
       :w, :int,
       :h, :int,
       :position, :int,
       :level, :uint8,
       :horizontal, :bool
    )
  end
  callback(:TCOD_bsp_callback_t, [ :pointer, :pointer ], :bool)
  tcod_function :TCOD_bsp_new, [  ], :pointer
  tcod_function :TCOD_bsp_new_with_size, [ :int, :int, :int, :int ], :pointer
  tcod_function :TCOD_bsp_delete, [ :pointer ], :void
  tcod_function :TCOD_bsp_left, [ :pointer ], :pointer
  tcod_function :TCOD_bsp_right, [ :pointer ], :pointer
  tcod_function :TCOD_bsp_father, [ :pointer ], :pointer
  tcod_function :TCOD_bsp_is_leaf, [ :pointer ], :bool
  tcod_function :TCOD_bsp_traverse_pre_order, [ :pointer, :TCOD_bsp_callback_t, :pointer ], :bool
  tcod_function :TCOD_bsp_traverse_in_order, [ :pointer, :TCOD_bsp_callback_t, :pointer ], :bool
  tcod_function :TCOD_bsp_traverse_post_order, [ :pointer, :TCOD_bsp_callback_t, :pointer ], :bool
  tcod_function :TCOD_bsp_traverse_level_order, [ :pointer, :TCOD_bsp_callback_t, :pointer ], :bool
  tcod_function :TCOD_bsp_traverse_inverted_level_order, [ :pointer, :TCOD_bsp_callback_t, :pointer ], :bool
  tcod_function :TCOD_bsp_contains, [ :pointer, :int, :int ], :bool
  tcod_function :TCOD_bsp_find_node, [ :pointer, :int, :int ], :pointer
  tcod_function :TCOD_bsp_resize, [ :pointer, :int, :int, :int, :int ], :void
  tcod_function :TCOD_bsp_split_once, [ :pointer, :bool, :int ], :void
  tcod_function :TCOD_bsp_split_recursive, [ :pointer, TCOD_random_t, :int, :int, :int, :float, :float ], :void
  tcod_function :TCOD_bsp_remove_sons, [ :pointer ], :void

  ### Heightmap module
  class TCODHeightmapT < MethodStruct
    layout(
       :w, :int,
       :h, :int,
       :values, :pointer
    )
  end

  TCOD_noise_t = :pointer

  tcod_function :TCOD_heightmap_new, [ :int, :int ], :pointer
  tcod_function :TCOD_heightmap_delete, [ :pointer ], :void
  tcod_function :TCOD_heightmap_get_value, [ :pointer, :int, :int ], :float
  tcod_function :TCOD_heightmap_get_interpolated_value, [ :pointer, :float, :float ], :float
  tcod_function :TCOD_heightmap_set_value, [ :pointer, :int, :int, :float ], :void
  tcod_function :TCOD_heightmap_get_slope, [ :pointer, :int, :int ], :float
  #tcod_function :TCOD_heightmap_get_normal, [ :pointer, :float, :float, [:float, 3], :float ], :void
  tcod_function :TCOD_heightmap_count_cells, [ :pointer, :float, :float ], :int
  tcod_function :TCOD_heightmap_has_land_on_border, [ :pointer, :float ], :bool
  tcod_function :TCOD_heightmap_get_minmax, [ :pointer, :pointer, :pointer ], :void
  tcod_function :TCOD_heightmap_copy, [ :pointer, :pointer ], :void
  tcod_function :TCOD_heightmap_add, [ :pointer, :float ], :void
  tcod_function :TCOD_heightmap_scale, [ :pointer, :float ], :void
  tcod_function :TCOD_heightmap_clamp, [ :pointer, :float, :float ], :void
  tcod_function :TCOD_heightmap_normalize, [ :pointer, :float, :float ], :void
  tcod_function :TCOD_heightmap_clear, [ :pointer ], :void
  tcod_function :TCOD_heightmap_lerp_hm, [ :pointer, :pointer, :pointer, :float ], :void
  tcod_function :TCOD_heightmap_add_hm, [ :pointer, :pointer, :pointer ], :void
  tcod_function :TCOD_heightmap_multiply_hm, [ :pointer, :pointer, :pointer ], :void
  tcod_function :TCOD_heightmap_add_hill, [ :pointer, :float, :float, :float, :float ], :void
  tcod_function :TCOD_heightmap_dig_hill, [ :pointer, :float, :float, :float, :float ], :void
  #tcod_function :TCOD_heightmap_dig_bezier, [ :pointer, [:int, 4], [:int, 4], :float, :float, :float, :float ], :void
  tcod_function :TCOD_heightmap_rain_erosion, [ :pointer, :int, :float, :float, TCOD_random_t ], :void
  tcod_function :TCOD_heightmap_kernel_transform, [ :pointer, :int, :pointer, :pointer, :pointer, :float, :float ], :void
  tcod_function :TCOD_heightmap_add_voronoi, [ :pointer, :int, :int, :pointer, TCOD_random_t ], :void
  tcod_function :TCOD_heightmap_add_fbm, [ :pointer, TCOD_noise_t, :float, :float, :float, :float, :float, :float, :float ], :void
  tcod_function :TCOD_heightmap_scale_fbm, [ :pointer, TCOD_noise_t, :float, :float, :float, :float, :float, :float, :float ], :void
  tcod_function :TCOD_heightmap_islandify, [ :pointer, :float, TCOD_random_t ], :void


  ### Name Generator module
  tcod_function :TCOD_namegen_parse, [ :string, TCOD_random_t ], :void
  tcod_function :TCOD_namegen_generate, [ :string, :bool ], :string
  tcod_function :TCOD_namegen_generate_custom, [ :string, :string, :bool ], :string
  tcod_function :TCOD_namegen_get_sets, [  ], TCOD_list_t
  tcod_function :TCOD_namegen_destroy, [  ], :void
end
