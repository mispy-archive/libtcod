module TCOD
  # Wrapper for FFI::Struct which allows access of
  # properties by method as well as indexing.

  class MethodStruct < FFI::Struct
    class << self
      alias_method :old_layout, :layout

      def layout(*keys)
        old_layout(*keys)
        keys.each_slice(2).each do |key,type|
          define_method(key) do
            self[key]
          end
        end
      end
    end
  end

  class MethodUnion < FFI::Union
    class << self
      alias_method :old_layout, :layout

      def layout(*keys)
        old_layout(*keys)
        keys.each_slice(2).each do |key,type|
          define_method(key) do
            self[key]
          end
        end
      end
    end
  end
end 
