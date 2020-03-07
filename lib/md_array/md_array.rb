module MdArray
  class MdArray
    def initialize(size, val = nil, &block)
      dim = size.length

      if dim.zero?
        @val = generate_val(val, block)
        @sub_arrays = nil
      else
        @sub_arrays = generate_sub_arrays(size, val, block)
      end
    end

    def size
      if dim_zero?
        []
      else
        [size_n, *sub_array.size]
      end
    end

    def dimension
      if dim_zero?
        0
      else
        1 + sub_array.dimension
      end
    end

    def valid_index?(index, strict: false)
      if dim_zero?
        index == []
      else
        index_n, *sub_index = index

        valid_index_n?(index_n, strict: strict) &&
          sub_array.valid_index?(sub_index, strict: strict)
      end
    end

    def at(index, strict: false)
      if dim_zero?
        @val
      else
        index_n, *sub_index = index

        valid_index_n?(index_n, strict: strict) || raise
        @sub_arrays[index_n].at(sub_index, strict: strict)
      end
    end

    def set(index, val, strict: false)
      if dim_zero?
        @val = val
      else
        index_n, *sub_index = index

        valid_index_n?(index_n, strict: strict) || raise
        @sub_arrays[index_n].set(sub_index, strict: strict)
      end
    end

    def [](index)
      at(index)
    end

    def []=(index, val)
      set(index, val)
    end

    def adjacent(index, strict: false)
      if dim_zero?
        []
      else
        index_n, *sub_index = index

        res = []

        if valid_index_n?(index_n - 1, strict: strict)
          res << @sub_arrays[index_n - 1].at(sub_index, strict: strict)
        end

        res += @sub_arrays[index_n].adjacent(sub_index, strict: strict)

        if valid_index_n?(index_n + 1, strict: strict)
          res << @sub_arrays[index_n + 1].at(sub_index, strict: strict)
        end

        res
      end
    end

    def neighborhood(index, strict: false)
      if dim_zero?
        []
      else
        index_n, *sub_index = index

        res = []

        if valid_index_n?(index_n - 1, strict: strict)
          res << @sub_arrays[index_n - 1].at(sub_index, strict: strict)
          res += @sub_arrays[index_n - 1].neighborhood(sub_index, strict: strict)
        end

        res += @sub_arrays[index_n].neighborhood(sub_index, strict: strict)

        if valid_index_n?(index_n + 1, strict: strict)
          res += @sub_arrays[index_n + 1].neighborhood(sub_index, strict: strict)
          res << @sub_arrays[index_n + 1].at(sub_index, strict: strict)
        end

        res
      end
    end

    def each
      raise NotImplementedError
    end

    private

    def generate_val(val, block)
      block ? block[] : val
    end

    def generate_sub_arrays(size, val, block)
      size_n, *sub_size = size

      Array.new(size_n) { |i| generate_sub_array(i, sub_size, val, block) }
    end

    def generate_sub_array(index, sub_size, val, block)
      sub_dim = sub_size.length

      if sub_dim.zero?
        val_ = block ? block[index] : val
        MdArray.new(sub_size, val_)
      else
        sub_block = block && block.curry[index]
        MdArray.new(sub_size, val, &sub_block)
      end
    end

    def dim_zero?
      @sub_arrays.nil?
    end

    def size_n
      @sub_arrays.length
    end

    def sub_array
      @sub_arrays[0]
    end

    def valid_index_n?(index_n, strict: false)
      !strict ||
        (0...size_n).include?(index_n)
    end
  end
end
