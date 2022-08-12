module MdArray
  class MdArray
    include Enumerable

    class Error < StandardError; end

    class InvalidSizeSpecified < ArgumentError; end

    def initialize(size, val = nil, &block)
      if size.length > 0
        size_n, *sub_size = size

        raise InvalidSizeSpecified unless size_n >= 1

        @sub_arrays = Array.new(size_n) { |i|
          MdArray.new(sub_size, val, &(FuncUtils.partial(block, i) if block))
        }
      else
        @val = block ? block[] : val
      end
    end

    def size
      if @sub_arrays
        size_n = @sub_arrays.length

        [size_n, *@sub_arrays.first.size]
      else
        []
      end
    end

    def dimension
      if @sub_arrays
        @sub_arrays.first.dimension + 1
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
      adjacent_with_index(index).lazy.map { |v, _| v }
    end

    def adjacent_with_index(index)
      validate_index(index)

      if @sub_arrays
        index_n, *sub_index = index
        size_n = @sub_arrays.length

        Enumerator::Chain.new(
          (0...size_n) === index_n - 1 ?
          [[@sub_arrays[index_n - 1].at(sub_index), [index_n - 1, *sub_index]]] : [],
          @sub_arrays[index_n].adjacent_with_index(sub_index)
                              .map { |v, si| [v, [index_n, *si]] },
          (0...size_n) === index_n + 1 ?
          [[@sub_arrays[index_n + 1].at(sub_index), [index_n + 1, *sub_index]]] : []
        )
      else
        []
      end
    end

    def neighborhood(index)
      neighborhood_with_index(index).lazy.map { |v, _| v }
    end

    def neighborhood_with_index(index)
      validate_index(index)

      if @sub_arrays
        index_n, *sub_index = index
        size_n = @sub_arrays.length

        Enumerator::Chain.new(
          (0...size_n) === index_n - 1 ?
          Enumerator::Chain.new([[@sub_arrays[index_n - 1].at(sub_index), [index_n - 1, *sub_index]]],
                                @sub_arrays[index_n - 1].neighborhood_with_index(sub_index)
                                                        .map { |v, si| [v, [index_n - 1, *si]] }) : [],
          @sub_arrays[index_n].neighborhood_with_index(sub_index)
                              .map { |v, si| [v, [index_n, *si]] },
          (0...size_n) === index_n + 1 ?
          Enumerator::Chain.new([[@sub_arrays[index_n + 1].at(sub_index), [index_n + 1, *sub_index]]],
                                @sub_arrays[index_n + 1].neighborhood_with_index(sub_index)
                                                        .map { |v, si| [v, [index_n + 1, *si]] }) : []
        )
      else
        []
      end
    end

    def enum
      if @sub_arrays
        @sub_arrays.map(&:enum).reduce(&:chain)
      else
        [@val]
      end
    end

    def enum_with_index
      if @sub_arrays
        @sub_arrays.each_with_index.map { |sub_array, index_n|
          sub_array.enum_with_index.map { |val, sub_index| [val, [index_n, *sub_index]] }
        }.reduce(&:chain)
      else
        [[@val, []]]
      end
    end

    def each(&block)
      if block
        enum.each(&block)

        self
      else
        enum
      end
    end

    def each_with_index(&block)
      if block
        enum_with_index.each(&block)

        self
      else
        enum_with_index
      end
    end

    alias_method :[], :at
    alias_method :[]=, :set

    private

    def validate_index(index)
      if @sub_arrays
        index_n, *_sub_index = index
        size_n = @sub_arrays.length

        raise IndexError unless index_n && (0...size_n) === index_n
      else
        raise IndexError unless index == []
      end
    end
  end
end
