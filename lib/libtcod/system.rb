module TCOD
  module System
    def self.register_sdl_renderer(&b)
      TCOD.sys_register_SDL_renderer(&b)
    end

    def self.screen_width
      @screen_width
    end

    def self.screen_height
      @screen_height
    end

    def self.init_tcod(options = {})
      @screen_width = options.fetch(:width, 80)
      @screen_height = options.fetch(:height, 25)
      @title = options.fetch(:title, '')
      fullscreen = options.fetch(:fullscreen, false)
      renderer = options.fetch(:renderer, RENDERER_SDL)

      TCOD.console_init_root(@screen_width,
                             @screen_height,
                             @title,
                             fullscreen,
                             renderer)
    end

    def self.title
      @title
    end

    def self.title=(new_title)
      @title = new_title
      TCOD.console_set_window_title(new_title)
    end

    def self.fullscreen?
      @fullscreen
    end

    def self.to_fullscreen
      @fullscreen = true
      TCOD.console_set_fullscreen(true)
    end

    def self.to_windowed
      @fullscreen = false
      TCOD.console_set_fullscreen(false)
    end

    def self.window_closed?
      TCOD.console_is_window_closed
    end

    def self.flush
      TCOD.console_flush
    end

    def self.check_for_keypress(flags = TCOD::KEY_PRESSED)
      TCOD.console_check_for_keypress(flags)
    end

    def self.wait_for_keypress(flush = false)
      TCOD.console_wait_for_keypress(flush)
    end

    def self.key_pressed?(keycode)
      TCOD.console_is_key_pressed(keycode)
    end

    def self.set_custom_font(font_file, flags, columns = 0, rows = 0)
      TCOD.console_set_custom_font(font_file, flags, columns, rows)
    end

    def self.map_ascii_code_to_font(ascii_code, coord)
      TCOD.console_map_ascii_code_to_font(ascii_code.ord, coord.x, coord.y)
    end

    def self.map_ascii_codes_to_font(ascii_code, n, offset)
      TCOD.console_map_ascii_code_to_font(ascii_code.ord, n, offset.x, offset.y)
    end
  end
end
