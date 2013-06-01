APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

module TCOD
  extend FFI::Library
  ffi_lib File.join(APP_ROOT, "libtcod-1.5.1/libtcod.so")

  def self.tcod_function(sym, *args)
    attach_function(sym[5..-1].to_sym, sym, *args)
  end

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
  EVENT_KEY = EVENT_KEY_PRESS|EVENT_KEY_RELEASE
  EVENT_ANY = EVENT_KEY|EVENT_MOUSE
  EVENT_MOUSE = EVENT_MOUSE_MOVE|EVENT_MOUSE_PRESS|EVENT_MOUSE_RELEASE

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
  tcod_function :TCOD_sys_get_sdl_window, [  ], :pointer

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
  attach_function :TCOD_mouse_includes_touch, [ :bool ], :void
  
  ### Color module
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
end
