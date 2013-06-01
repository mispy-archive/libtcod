module TCOD
  class Console
    def self.root
      @root ||= Console.new(0, 0, true)
    end

    def initialize(w, h, root=False)
      if root
        @ptr = nil
      else
        @ptr = C.console_new(w, h)
      end
    end

    def init_root(width, height, title, fullscreen=false, renderer=:renderer_sdl)
      C.console_init_root(width, height, title, fullscreen, renderer)
    end

    def window_closed?
      C.console_is_window_closed
    end

    def set_default_foreground(color)
      C.console_set_default_foreground(@ptr, color)
    end

    def put_char(x, y, c, flag=:bkgnd_default)
      C.console_put_char(@ptr, x, y, c.ord, flag)
    end

    def flush
      C.console_flush
    end
  end
end
