module TCOD
  class RootConsole < Console
    private_class_method :new

    def initialize
      @width = System.screen_width
      @height = System.screen_height
      @ptr = nil
    end

    def root?
      true
    end
  end
end
