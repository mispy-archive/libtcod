module TCOD
  class Console
    attr_accessor :width, :height, :ptr

    def self.root
      @root ||= TCOD::Console.new(0, 0, true)
    end

    def initialize(w, h, root=false)
      if root
        @ptr = nil
      else
        @width = w
        @height = w
        @ptr = TCOD.console_new(w, h)
      end

      ObjectSpace.define_finalizer(self, self.class.finalize(ptr))
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

    def set_char_background(x, y, col, flag=TCOD::BKGND_SET)
      TCOD.console_set_char_background(@ptr, x, y, col, flag)
    end

    def set_char_foreground(x, y, col)
      TCOD.console_set_char_foreground(@ptr, x, y, col)
    end

    def put_char(x, y, c, flag=BKGND_DEFAULT)
      TCOD.console_put_char(@ptr, x, y, c.ord, flag)
    end
    def put_char_ex(x, y, c, foreground, background)
      TCOD.console_put_char_ex(@ptr, x, y, c.ord, foreground, background)
    end
    def set_background_flag(bkgnd_flag)
      TCOD.console_set_background_flag(@ptr, bkgnd_flag)
    end
    def set_alignment(alignment)
      TCOD.console_set_alignment(@ptr, alignment)
    end
    def print(x, y, fmt, *args)
      TCOD.console_print(@ptr, x, y, fmt, *args)
    end
    def print_ex(x, y, bkgnd_flag, alignment, fmt, *args)
      TCOD.console_print_ex(@ptr, x, y, bkgnd_flag, alignment, fmt, *args)
    end
    def print_rect(x, y, w, h, fmt, *args)
      TCOD.console_print_rect(@ptr, x, y, w, h, fmt, *args)
    end
    def print_rect_ex(x, y, w, h, bkgnd_flag, alignment, fmt, *args)
      TCOD.console_print_rect_ex(@ptr, x, y, w, h, bkgnf_flag, alignment, fmt, *args)
    end

    def flush; TCOD.console_flush; end

    def check_for_keypress(flags=TCOD::KEY_PRESSED); TCOD.console_check_for_keypress(flags); end
    def wait_for_keypress(flush=false); TCOD.console_wait_for_keypress(flush); end
    def key_pressed?(keycode); TCOD.console_is_key_pressed(keycode); end

    def blit(src, xSrc, ySrc, wSrc, hSrc, xDst, yDst, foregroundAlpha=1.0, backgroundAlpha=1.0)
      TCOD.console_blit(src.ptr, xSrc, ySrc, wSrc, hSrc, @ptr, xDst, yDst, foregroundAlpha, backgroundAlpha)
    end

    def self.finalize(ptr)
      proc { TCOD.console_delete(ptr) }
    end
  end
end
