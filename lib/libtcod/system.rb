module TCOD
  module System
    def self.register_sdl_renderer(&b)
      TCOD.sys_register_SDL_renderer(&b)
    end
  end
end
