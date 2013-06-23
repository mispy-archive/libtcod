# libtcod-ruby 0.0.4

Ruby bindings for [libtcod 1.5.1](http://doryen.eptalys.net/libtcod/)

Currently tested on Linux and Windows using Ruby 1.9.3; other platforms may work if you have libtcod in a place where ffi\_lib knows to get it. Basic wrapping of the C functions is complete, and a more idiomatic Ruby API is in progress.

## Installation

    gem install libtcod

## Examples

Here's a straight port of the [example code](http://roguebasin.roguelikedevelopment.org/index.php?title=Complete_Roguelike_Tutorial,_using_python%2Blibtcod,_part_1_code#Moving_around) from part 1 of the python tutorial:

```ruby
require 'libtcod'

#actual size of the window
SCREEN_WIDTH = 80
SCREEN_HEIGHT = 50

LIMIT_FPS = 20  #20 frames-per-second maximum

def handle_keys
  #key = TCOD.console_check_for_keypress()  #real-time
  key = TCOD.console_wait_for_keypress(true)  #turn-based

  if key.vk == TCOD::KEY_ENTER && key.lalt
    #Alt+Enter: toggle fullscreen
    TCOD.console_set_fullscreen(!TCOD.console_is_fullscreen())
  elsif key.vk == TCOD::KEY_ESCAPE
    return true  #exit game
  end

  #movement keys
  if TCOD.console_is_key_pressed(TCOD::KEY_UP)
      $playery -= 1
  elsif TCOD.console_is_key_pressed(TCOD::KEY_DOWN)
      $playery += 1
  elsif TCOD.console_is_key_pressed(TCOD::KEY_LEFT)
      $playerx -= 1
  elsif TCOD.console_is_key_pressed(TCOD::KEY_RIGHT)
      $playerx += 1
  end

  false
end

#############################################
# Initialization & Main Loop
#############################################

TCOD.console_set_custom_font('arial10x10.png', TCOD::FONT_TYPE_GREYSCALE | TCOD::FONT_LAYOUT_TCOD, 0, 0)
TCOD.console_init_root(SCREEN_WIDTH, SCREEN_HEIGHT, 'ruby/TCOD tutorial', false, TCOD::RENDERER_SDL)
TCOD.sys_set_fps(LIMIT_FPS)

$playerx = SCREEN_WIDTH/2
$playery = SCREEN_HEIGHT/2

until TCOD.console_is_window_closed
  TCOD.console_set_default_foreground(nil, TCOD::Color::WHITE)
  TCOD.console_put_char(nil, $playerx, $playery, '@'.ord, TCOD::BKGND_NONE)

  TCOD.console_flush()

  TCOD.console_put_char(nil, $playerx, $playery, ' '.ord, TCOD::BKGND_NONE)

  #handle keys and exit game if needed
  will_exit = handle_keys
  break if will_exit
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
