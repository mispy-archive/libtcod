module TCOD
  class Console
    attr_accessor :width, :height

    def self.root
      @root ||= TCOD::Console.new(0, 0, true)
    end

    def initialize(w, h, root=False)
      if root
        @ptr = nil
      else
        @width = w
        @height = w
        @ptr = TCOD.console_new(w, h)
      end
    end

    def init_root(width, height, title, fullscreen=false, renderer=RENDERER_SDL)
      TCOD.console_init_root(width, height, title, fullscreen, renderer)
      Console.root.width = width
      Console.root.height = height
    end

    def set_window_title(title); TCOD.console_set_window_title(title); end
    def set_fullscreen(bool); TCOD.console_set_fullscreen(bool); end
    def is_fullscreen?; TCOD.console_is_fullscreen; end
    def window_closed?; TCOD.console_is_window_closed; end
    def set_custom_font(fontFile, flags, nb_char_horiz=0, nb_char_vertic=0)
      TCOD.console_set_custom_font(fontFile, flags, nb_char_horiz, nb_char_vertic)
    end
    def map_ascii_code_to_font(asciiCode, fontCharX, fontCharY)
      TCOD.console_map_ascii_code_to_font(asciiCode.ord, fontCharX, fontCharY)
    end
    def map_ascii_codes_to_font(asciiCode, nbCodes, fontCharX, fontCharY)
      TCOD.console_map_ascii_code_to_font(asciiCode.ord, nbCodes, fontCharX, fontCharY)
    end


    def set_default_background(color); TCOD.console_set_default_background(@ptr, color); end
    def set_default_foreground(color); TCOD.console_set_default_foreground(@ptr, color); end
    def clear; TCOD.console_clear(@ptr); end

    def put_char(x, y, c, flag=BKGND_DEFAULT)
      TCOD.console_put_char(@ptr, x, y, c.ord, flag)
    end

    def flush; TCOD.console_flush; end

    def wait_for_keypress(flush=false); TCOD.console_wait_for_keypress(flush); end
    def key_pressed?(keycode); TCOD.console_is_key_pressed(keycode); end
  end
end
