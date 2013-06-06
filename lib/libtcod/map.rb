module TCOD
  class Map
    attr_reader :ptr

    def initialize(width, height)
      @ptr = TCOD.map_new(width, height)
    end

    def set_properties(x, y, is_transparent, is_walkable)
      TCOD.map_set_properties(@ptr, x, y, is_transparent, is_walkable)
    end

    def compute_fov(x, y, max_radius, light_walls, algo)
      TCOD.map_compute_fov(@ptr, x, y, max_radius, light_walls, algo)
    end
  end

  class Path
    attr_reader :ptr

    def self.using_map(tcod_map, diagonalCost=1.41)
      Path.new TCOD.path_new_using_map(tcod_map.ptr, diagonalCost)
    end

    # Generally shouldn't be called directly
    def initialize(ptr)
      @ptr = ptr
    end

    # Compute a path between two points
    # ox, oy - Coordinates of the origin of the path
    # dx, dy - Coordinates of the destination of the path
    # Returns false if there is no possible path.
    def compute(ox, oy, dx, dy)
      TCOD.path_compute(@ptr, ox, oy, dx, dy)
    end

    def walk(recalculate_when_needed=true)
      px = FFI::MemoryPointer.new(:int)
      py = FFI::MemoryPointer.new(:int)
      if TCOD.path_walk(@ptr, px, py, recalculate_when_needed)
        [px.read_int, py.read_int]
      else
        false
      end
    end

    def empty?; TCOD.path_is_empty(@ptr); end
    def size; TCOD.path_size(@ptr); end
    def reverse!; TCOD.path_reverse(@ptr); end

    def [](index)
      px = FFI::MemoryPointer.new(:int)
      py = FFI::MemoryPointer.new(:int)
      TCOD.path_get(@ptr, index, px, py)
      [px.read_int, py.read_int]
    end

    def origin
      px = FFI::MemoryPointer.new(:int)
      py = FFI::MemoryPointer.new(:int)
      TCOD.path_get_origin(@ptr, px, py)
      [px.read_int, py.read_int]
    end

    def destination
      px = FFI::MemoryPointer.new(:int)
      py = FFI::MemoryPointer.new(:int)
      TCOD.path_get_destination(@ptr, px, py)
      [px.read_int, py.read_int]
    end

    def self.finalize(ptr)
      proc { TCOD.path_delete(ptr) }
    end
  end
end
