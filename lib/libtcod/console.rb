module TCOD
  class Console
    attr_accessor :width, :height

    def self.root
      @root ||= TCOD.nsole.new(0, 0, true)
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

    def self.init_root(width, height, title, fullscreen=false, renderer=RENDERER_SDL)
      TCOD.console_init_root(width, height, title, fullscreen, renderer)
      root.width = width
      root.height = height
      root
    end

    def window_closed?
      TCOD.console_is_window_closed
    end

    def set_default_foreground(color)
      TCOD.console_set_default_foreground(@ptr, color)
    end

    def put_char(x, y, c, flag=BKGND_DEFAULT)
      TCOD.console_put_char(@ptr, x, y, c.ord, flag)
    end

    def flush
      TCOD.console_flush
    end

    def wait_for_keypress(flush=false)
      TCOD.console_wait_for_keypress(flush)
    end
  end
end
