require "md_array/utils"

module MdArray
  class MdArray
    def initialize(size, val = nil, &block)
      if size.length > 0
        size_n, *sub_size = size

        @sub_arrays = Array.new(size_n) { |i|
          MdArray.new(sub_size,
                      val,
                      &(block && Utils.partial(block, i)))
        }
      else
        @val = block ? block[] : val
      end
    end

    def size
      if @sub_arrays
        size_n = @sub_arrays.length

        [size_n, *@sub_arrays[0].size]
      else
        []
      end
    end

    def dimension
      if @sub_arrays
        1 + @sub_arrays[0].dimension
      else
        0
      end
    end

    def at(index)
      validate_index(index)

      if @sub_arrays
        index_n, *sub_index = index

        @sub_arrays[index_n].at(sub_index)
      else
        @val
      end
    end

    def set(index, val)
      validate_index(index)

      if @sub_arrays
        index_n, *sub_index = index

        @sub_arrays[index_n].set(sub_index, val)
      else
        @val = val
      end
    end

    def adjacent(index)
      validate_index(index)

      if @sub_arrays
        index_n, *sub_index = index
        size_n = @sub_arrays.length

        Enumerator::Chain.new(
          (0...size_n) === index_n - 1 ?
          [@sub_arrays[index_n - 1].at(sub_index)] : [],
          @sub_arrays[index_n].adjacent(sub_index),
          (0...size_n) === index_n + 1 ?
          [@sub_arrays[index_n + 1].at(sub_index)] : []
        )
      else
        []
      end
    end

    def neighborhood(index)
      validate_index(index)

      if @sub_arrays
        index_n, *sub_index = index
        size_n = @sub_arrays.length

        Enumerator::Chain.new(
          (0...size_n) === index_n - 1 ?
          Enumerator::Chain.new([@sub_arrays[index_n - 1].at(sub_index)],
                                @sub_arrays[index_n - 1].neighborhood(sub_index)) : [],
          @sub_arrays[index_n].neighborhood(sub_index),
          (0...size_n) === index_n + 1 ?
          Enumerator::Chain.new([@sub_arrays[index_n + 1].at(sub_index)],
                                @sub_arrays[index_n + 1].neighborhood(sub_index)) : []
        )
      else
        []
      end
    end

    alias_method :[], :at
    alias_method :[]=, :set

    private

    def validate_index(index)
      if @sub_arrays
        index_n, *sub_index = index
        size_n = @sub_arrays.length

        raise IndexError unless (0...size_n) === index_n
      else
        raise IndexError unless index == []
      end
    end
  end
end
