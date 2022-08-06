module MdArray
  module FuncUtils
    class << self
      def partial(f, *args)
        proc { |*rest_args| f[*args, *rest_args] }
      end
    end
  end
end
