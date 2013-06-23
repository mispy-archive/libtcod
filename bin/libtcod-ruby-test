#!/usr/bin/env ruby

#
# TCOD ruby tutorial with tiles
#

require 'libtcod'

#actual size of the window
SCREEN_WIDTH = 50
SCREEN_HEIGHT = 37

#size of the $map
MAP_WIDTH = SCREEN_WIDTH
MAP_HEIGHT = SCREEN_HEIGHT

#parameters for dungeon generator
ROOM_MAX_SIZE = 10
ROOM_MIN_SIZE = 6
MAX_ROOMS = 30

FOV_ALGO = 0  #default FOV algorithm
FOV_LIGHT_WALLS = true  #light walls or not
TORCH_RADIUS = 10

LIMIT_FPS = 20  #20 frames-per-second maximum

GROUND_COLOR = TCOD::Color.rgb(77, 60, 41)

WALL_TILE = 256  #first tile in the first row of tiles
MAGE_TILE = 256 + 32  #first tile in the 2nd row of tiles
SKELETON_TILE = 256 + 32 + 1  #2nd tile in the 2nd row of tiles

class Tile
  attr_accessor :blocked, :explored, :block_sight

  #a tile of the $map and its properties
  def initialize(blocked, block_sight = nil)
    @blocked = blocked

    #all tiles start unexplored
    @explored = false

    #by default, if a tile.equal? blocked, it also blocks sight
    if block_sight.nil?
      @block_sight = blocked
    else
      @block_sight = block_sight
    end
  end
end

class Rect
  attr_accessor :x1, :y1, :x2, :y2
  #a rectangle on the $map. used to characterize a room.
  def initialize (x, y, w, h)
    @x1 = x
    @y1 = y
    @x2 = x + w
    @y2 = y + h
  end
 
  def center
    center_x = (@x1 + @x2) / 2
    center_y = (@y1 + @y2) / 2
    [center_x, center_y]
  end
 
  def intersect (other)
    #returns true if this rectangle intersects with another one
    return (@x1 <= other.x2 and @x2 >= other.x1 and
      @y1 <= other.y2 and @y2 >= other.y1)
  end
end

class Obj
  attr_accessor :x, :y, :char, :color

  #this.equal? a generic object: the $player, a monster, an item, the stairs...
  #it's always represented by a character on screen.
  def initialize (x, y, char, color)
    @x = x
    @y = y
    @char = char
    @color = color
  end
 
  def move (dx, dy)
    #move by the given amount, if the destination.equal? not blocked
    if not $map[@x + dx][@y + dy].blocked
      @x += dx
      @y += dy
    end
  end
 
  def draw
    #only show if it's visible to the $player
    if TCOD.map_is_in_fov($fov_map, @x, @y)
      #set the color and then draw the character that represents this object at its position
      TCOD.console_set_default_foreground($con, @color)
      TCOD.console_put_char($con, @x, @y, @char.ord, TCOD::BKGND_NONE)
    end
  end
 
  def clear
    #erase the character that represents this object
    TCOD.console_put_char($con, @x, @y, ' '.ord, TCOD::BKGND_NONE)
  end
end

def create_room(room)
  #go through the tiles in the rectangle and make them passable
  p "#{room.x1}, #{room.x2}, #{room.y1}, #{room.y2}"
  (room.x1 + 1 ... room.x2).each do |x|
    (room.y1 + 1 ... room.y2).each do |y|
      $map[x][y].blocked = false
      $map[x][y].block_sight = false
    end
  end
end

def create_h_tunnel(x1, x2, y)
  #horizontal tunnel. min() and max() are used in case x1>x2
  ([x1,x2].min ... [x1,x2].max + 1).each do |x|
    $map[x][y].blocked = false
    $map[x][y].block_sight = false
  end
end

def create_v_tunnel(y1, y2, x)
  #vertical tunnel
  ([y1,y2].min ... [y1,y2].max + 1).each do |y|
    $map[x][y].blocked = false
    $map[x][y].block_sight = false
  end
end

def make_map
  # fill $map with "blocked" tiles
  #$map = [[0]*MAP_HEIGHT]*MAP_WIDTH
  $map = []
  0.upto(MAP_WIDTH-1) do |x|
    $map.push([])
    0.upto(MAP_HEIGHT-1) do |y|
      $map[x].push(Tile.new(true))
    end
  end

  rooms = []
  num_rooms = 0

  0.upto(MAX_ROOMS) do |r|
    #random width and height
    w = TCOD.random_get_int(nil, ROOM_MIN_SIZE, ROOM_MAX_SIZE)
    h = TCOD.random_get_int(nil, ROOM_MIN_SIZE, ROOM_MAX_SIZE)
    #random position without going out of the boundaries of the $map
    x = TCOD.random_get_int(nil, 0, MAP_WIDTH - w - 1)
    y = TCOD.random_get_int(nil, 0, MAP_HEIGHT - h - 1)


    #"Rect" class makes rectangles easier to work with
    new_room = Rect.new(x, y, w, h)

    #run through the other rooms and see if they intersect with this one
    failed = false
    rooms.each do |other_room|
      if new_room.intersect(other_room)
        failed = true
        break
      end
    end

    unless failed
      #this means there are no intersections, so this room.equal? valid

      #"paint" it to the $map's tiles
      create_room(new_room)

      #center coordinates of new room, will be useful later
      new_x, new_y = new_room.center


      #there's a 30% chance of placing a skeleton slightly off to the center of this room
      if TCOD.random_get_int(nil, 1, 100) <= 30
        skeleton = Obj.new(new_x + 1, new_y, SKELETON_TILE, TCOD::Color::LIGHT_YELLOW)
        $objects.push(skeleton)
      end

      if num_rooms == 0
        #this.equal? the first room, where the $player starts at
        $player.x = new_x
        $player.y = new_y
      else
        #all rooms after the first
        #connect it to the previous room with a tunnel

        #center coordinates of previous room
        prev_x, prev_y = rooms[num_rooms-1].center()

        #draw a coin(random number that.equal? either 0 or 1)
        if TCOD.random_get_int(nil, 0, 1) == 1
          #first move horizontally, then vertically
          create_h_tunnel(prev_x, new_x, prev_y)
          create_v_tunnel(prev_y, new_y, new_x)
        else
          #first move vertically, then horizontally
          create_v_tunnel(prev_y, new_y, prev_x)
          create_h_tunnel(prev_x, new_x, new_y)
        end
      end

      #finally, append the new room to the list
      rooms.push(new_room)
      num_rooms += 1
    end
  end
end


def render_all
  if $fov_recompute
    #recompute FOV if needed(the $player moved or something)
    $fov_recompute = false
    TCOD.map_compute_fov($fov_map, $player.x, $player.y, TORCH_RADIUS, FOV_LIGHT_WALLS, FOV_ALGO)

    #go through all tiles, and set their background color according to the FOV
    0.upto(MAP_HEIGHT-1) do |y|
      0.upto(MAP_WIDTH-1) do |x|
        visible = TCOD.map_is_in_fov($fov_map, x, y)
        wall = $map[x][y].block_sight
        if not visible
          #if it's not visible right now, the $player can only see it if it's explored
          if $map[x][y].explored
            if wall
              TCOD.console_put_char_ex($con, x, y, WALL_TILE.ord, TCOD::Color::WHITE * 0.5, TCOD::Color::BLACK)
            else
              TCOD.console_put_char_ex($con, x, y, ' '.ord, TCOD::Color::BLACK, GROUND_COLOR * 0.5)
            end
          end
        else
          #it's visible
          if wall
            TCOD.console_put_char_ex($con, x, y, WALL_TILE.ord, TCOD::Color::WHITE, TCOD::Color::BLACK)
          else
            TCOD.console_put_char_ex($con, x, y, ' '.ord, TCOD::Color::BLACK, GROUND_COLOR)
          end
          #since it's visible, explore it
          $map[x][y].explored = true
        end
      end
    end
  end

  #draw all objects in the list
  $objects.each do |object|
    object.draw()
  end

  #blit the contents of "con" to the root console
  TCOD.console_blit($con, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, nil, 0, 0, 1.0, 1.0)
end

def handle_keys
  #key = TCOD.console_check_for_keypress()  #real-time
  key = TCOD.console_wait_for_keypress(true)  #turn-based

  if key.vk == TCOD::KEY_ENTER and key.lalt
    #Alt+Enter: toggle fullscreen
    TCOD.console_set_fullscreen(!TCOD.console_is_fullscreen)
  elsif key.vk == TCOD::KEY_ESCAPE
    return true  #exit game
  end

  #movement keys
  if TCOD.console_is_key_pressed(TCOD::KEY_UP)
    $player.move(0, -1)
    $fov_recompute = true
  elsif TCOD.console_is_key_pressed(TCOD::KEY_DOWN)
    $player.move(0, 1)
    $fov_recompute = true
  elsif TCOD.console_is_key_pressed(TCOD::KEY_LEFT)
    $player.move(-1, 0)
    $fov_recompute = true
  elsif TCOD.console_is_key_pressed(TCOD::KEY_RIGHT)
    $player.move(1, 0)
    $fov_recompute = true
  end
  false
end


#############################################
# Initialization & Main Loop
#############################################

#note that we must specify the number of tiles on the font, which was enlarged a bit
TCOD.console_set_custom_font(File.join(File.dirname(__FILE__), 'oryx_tiles.png'), TCOD::FONT_TYPE_GREYSCALE | TCOD::FONT_LAYOUT_TCOD, 32, 12)
TCOD.console_init_root(SCREEN_WIDTH, SCREEN_HEIGHT, 'python/TCOD tutorial', false, TCOD::RENDERER_SDL)
TCOD.sys_set_fps(LIMIT_FPS)
$con = TCOD.console_new(SCREEN_WIDTH, SCREEN_HEIGHT)


TCOD.console_map_ascii_codes_to_font(256, 32, 0, 5)  #$map all characters in 1st row
TCOD.console_map_ascii_codes_to_font(256+32, 32, 0, 6)  #$map all characters in 2nd row


#create object representing the $player
$player = Obj.new(0, 0, MAGE_TILE, TCOD::Color::WHITE)

#the list of objects with just the $player
$objects = [$player]

#generate $map(at this point it's not drawn to the screen)
make_map()

#create the FOV $map, according to the generated $map
$fov_map = TCOD.map_new(MAP_WIDTH, MAP_HEIGHT)
0.upto(MAP_HEIGHT-1) do |y|
  0.upto(MAP_WIDTH-1) do |x|
    TCOD.map_set_properties($fov_map, x, y, !$map[x][y].block_sight, !$map[x][y].blocked)
  end
end


$fov_recompute = true

trap('SIGINT') { exit! }

until TCOD.console_is_window_closed()
 
 #render the screen
 render_all()
 
 TCOD.console_flush()
 
 #erase all objects at their old locations, before they move
 $objects.each do |object|
   object.clear()
 end

 #handle keys and exit game if needed
 will_exit = handle_keys()
 break if will_exit
end
