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
  end
end
