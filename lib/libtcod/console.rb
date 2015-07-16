module TCOD
  class Console
    attr_accessor :width, :height, :ptr

    def self.root
      @instance = new RootConsole
    end

    def initialize(width, height)
      @width = w
      @height = h
      @ptr = TCOD.console_new(w, h)

      # Note: We don't need to define a finalizer for the root console!
      ObjectSpace.define_finalizer(self, self.class.finalize(ptr))
    end

    def root?
      false
    end

    def set_default_background(color)
      TCOD.console_set_default_background(@ptr, color)
    end

    def set_default_foreground(color)
      TCOD.console_set_default_foreground(@ptr, color)
    end

    def clear
      TCOD.console_clear(@ptr)
    end

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

    def flush
      TCOD.console_flush
    end

    def blit(src, xSrc, ySrc, wSrc, hSrc, xDst, yDst, foregroundAlpha=1.0, backgroundAlpha=1.0)
      TCOD.console_blit(src.ptr, xSrc, ySrc, wSrc, hSrc, @ptr, xDst, yDst, foregroundAlpha, backgroundAlpha)
    end

    def self.finalize(ptr)
      proc { TCOD.console_delete(ptr) }
    end
  end
end
