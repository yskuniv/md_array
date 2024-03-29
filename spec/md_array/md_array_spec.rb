RSpec.describe MdArray do
  describe MdArray do
    describe "new" do
      where(:size) do
        [
          [[0]],
          [[0, 1]],
          [[1, 0]],
        ]
      end

      with_them do
        it "raises InvalidSizeSpecified when invalid size specified" do
          expect {
            MdArray::MdArray.new(size)
          }.to raise_error(MdArray::MdArray::InvalidSizeSpecified)
        end
      end
    end

    describe "size" do
      where(:size) do
        [
          [[]],
          [[1]],
          [[2]],
          [[3]],
          [[1, 1]],
          [[1, 2]],
          [[1, 3]],
          [[2, 1]],
          [[2, 2]],
          [[2, 3]],
          [[3, 1]],
          [[3, 2]],
          [[3, 3]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new(size)
          expect(md.size).to eq size
        end
      end
    end

    describe "dimension" do
      where(:size, :expected) do
        [
          [[], 0],
          [[1], 1],
          [[1, 1], 2]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new(size)
          expect(md.dimension).to eq expected
        end
      end
    end

    describe "[]" do
      where(:index, :expected) do
        [
          [[0, 0, 0], [0, 0, 0]],
          [[1, 1, 1], [1, 1, 1]],
          [[2, 2, 2], [2, 2, 2]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([3, 3, 3]) { |z, y, x| [z, y, x] }
          expect(md[index]).to eq expected
        end
      end
    end

    describe "adjacent" do
      where(:index, :expected) do
        [
          [[0, 0, 0], [[0, 0, 1],
                       [0, 1, 0],
                       [1, 0, 0]]],
          [[2, 2, 2], [[1, 2, 2],
                       [2, 1, 2],
                       [2, 2, 1], [2, 2, 3],
                       [2, 3, 2],
                       [3, 2, 2]]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([5, 5, 5]) { |z, y, x| [z, y, x] }
          expect(md.adjacent(index)).to match_array expected
        end
      end
    end

    describe "adjacent_index" do
      where(:index, :expected) do
        [
          [[0, 0, 0], [[0, 0, 1],
                       [0, 1, 0],
                       [1, 0, 0]]],
          [[2, 2, 2], [[1, 2, 2],
                       [2, 1, 2],
                       [2, 2, 1], [2, 2, 3],
                       [2, 3, 2],
                       [3, 2, 2]]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([5, 5, 5], 0)
          expect(md.adjacent_index(index)).to match_array expected
        end
      end
    end

    describe "adjacent_with_index" do
      where(:index, :expected) do
        [
          [[0, 0, 0], [[[0, 0, 1], [0, 0, 1]],
                       [[0, 1, 0], [0, 1, 0]],
                       [[1, 0, 0], [1, 0, 0]]]],
          [[2, 2, 2], [[[1, 2, 2], [1, 2, 2]],
                       [[2, 1, 2], [2, 1, 2]],
                       [[2, 2, 1], [2, 2, 1]], [[2, 2, 3], [2, 2, 3]],
                       [[2, 3, 2], [2, 3, 2]],
                       [[3, 2, 2], [3, 2, 2]]]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([5, 5, 5]) { |z, y, x| [z, y, x] }
          expect(md.adjacent_with_index(index)).to match_array expected
        end
      end
    end

    describe "neighborhood" do
      where(:index, :expected) do
        [
          [[0, 0, 0], [[0, 0, 1],
                       [0, 1, 0], [0, 1, 1],
                       [1, 0, 0], [1, 0, 1],
                       [1, 1, 0], [1, 1, 1]]],
          [[2, 2, 2], [[1, 1, 1], [1, 1, 2], [1, 1, 3],
                       [1, 2, 1], [1, 2, 2], [1, 2, 3],
                       [1, 3, 1], [1, 3, 2], [1, 3, 3],
                       [2, 1, 1], [2, 1, 2], [2, 1, 3],
                       [2, 2, 1], [2, 2, 3],
                       [2, 3, 1], [2, 3, 2], [2, 3, 3],
                       [3, 1, 1], [3, 1, 2], [3, 1, 3],
                       [3, 2, 1], [3, 2, 2], [3, 2, 3],
                       [3, 3, 1], [3, 3, 2], [3, 3, 3]]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([5, 5, 5]) { |z, y, x| [z, y, x] }
          expect(md.neighborhood(index)).to match_array expected
        end
      end
    end

    describe "neighborhood_index" do
      where(:index, :expected) do
        [
          [[0, 0, 0], [[0, 0, 1],
                       [0, 1, 0], [0, 1, 1],
                       [1, 0, 0], [1, 0, 1],
                       [1, 1, 0], [1, 1, 1]]],
          [[2, 2, 2], [[1, 1, 1], [1, 1, 2], [1, 1, 3],
                       [1, 2, 1], [1, 2, 2], [1, 2, 3],
                       [1, 3, 1], [1, 3, 2], [1, 3, 3],
                       [2, 1, 1], [2, 1, 2], [2, 1, 3],
                       [2, 2, 1], [2, 2, 3],
                       [2, 3, 1], [2, 3, 2], [2, 3, 3],
                       [3, 1, 1], [3, 1, 2], [3, 1, 3],
                       [3, 2, 1], [3, 2, 2], [3, 2, 3],
                       [3, 3, 1], [3, 3, 2], [3, 3, 3]]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([5, 5, 5], 0)
          expect(md.neighborhood_index(index)).to match_array expected
        end
      end
    end

    describe "neighborhood_with_index" do
      where(:index, :expected) do
        [
          [[0, 0, 0], [[[0, 0, 1], [0, 0, 1]],
                       [[0, 1, 0], [0, 1, 0]], [[0, 1, 1], [0, 1, 1]],
                       [[1, 0, 0], [1, 0, 0]], [[1, 0, 1], [1, 0, 1]],
                       [[1, 1, 0], [1, 1, 0]], [[1, 1, 1], [1, 1, 1]]]],
          [[2, 2, 2], [[[1, 1, 1], [1, 1, 1]], [[1, 1, 2], [1, 1, 2]], [[1, 1, 3], [1, 1, 3]],
                       [[1, 2, 1], [1, 2, 1]], [[1, 2, 2], [1, 2, 2]], [[1, 2, 3], [1, 2, 3]],
                       [[1, 3, 1], [1, 3, 1]], [[1, 3, 2], [1, 3, 2]], [[1, 3, 3], [1, 3, 3]],
                       [[2, 1, 1], [2, 1, 1]], [[2, 1, 2], [2, 1, 2]], [[2, 1, 3], [2, 1, 3]],
                       [[2, 2, 1], [2, 2, 1]], [[2, 2, 3], [2, 2, 3]],
                       [[2, 3, 1], [2, 3, 1]], [[2, 3, 2], [2, 3, 2]], [[2, 3, 3], [2, 3, 3]],
                       [[3, 1, 1], [3, 1, 1]], [[3, 1, 2], [3, 1, 2]], [[3, 1, 3], [3, 1, 3]],
                       [[3, 2, 1], [3, 2, 1]], [[3, 2, 2], [3, 2, 2]], [[3, 2, 3], [3, 2, 3]],
                       [[3, 3, 1], [3, 3, 1]], [[3, 3, 2], [3, 3, 2]], [[3, 3, 3], [3, 3, 3]]]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([5, 5, 5]) { |z, y, x| [z, y, x] }
          expect(md.neighborhood_with_index(index)).to match_array expected
        end
      end
    end

    describe "each" do
      it "responds correctly" do
        md = MdArray::MdArray.new([3, 3, 3]) { |z, y, x| [z, y, x] }
        expect(md.each).to match_array [[0, 0, 0], [0, 0, 1], [0, 0, 2],
                                        [0, 1, 0], [0, 1, 1], [0, 1, 2],
                                        [0, 2, 0], [0, 2, 1], [0, 2, 2],
                                        [1, 0, 0], [1, 0, 1], [1, 0, 2],
                                        [1, 1, 0], [1, 1, 1], [1, 1, 2],
                                        [1, 2, 0], [1, 2, 1], [1, 2, 2],
                                        [2, 0, 0], [2, 0, 1], [2, 0, 2],
                                        [2, 1, 0], [2, 1, 1], [2, 1, 2],
                                        [2, 2, 0], [2, 2, 1], [2, 2, 2]]
      end

      it "returns self if called with block" do
        md = MdArray::MdArray.new([])
        expect(md.each { |_| }).to eq md # rubocop:disable Lint/EmptyBlock
      end
    end

    describe "each_index" do
      it "responds correctly" do
        md = MdArray::MdArray.new([3, 3, 3], 0)
        expect(md.each_index).to match_array [[0, 0, 0], [0, 0, 1], [0, 0, 2],
                                              [0, 1, 0], [0, 1, 1], [0, 1, 2],
                                              [0, 2, 0], [0, 2, 1], [0, 2, 2],
                                              [1, 0, 0], [1, 0, 1], [1, 0, 2],
                                              [1, 1, 0], [1, 1, 1], [1, 1, 2],
                                              [1, 2, 0], [1, 2, 1], [1, 2, 2],
                                              [2, 0, 0], [2, 0, 1], [2, 0, 2],
                                              [2, 1, 0], [2, 1, 1], [2, 1, 2],
                                              [2, 2, 0], [2, 2, 1], [2, 2, 2]]
      end

      it "returns self if called with block" do
        md = MdArray::MdArray.new([])
        expect(md.each_index { |_| }).to eq md # rubocop:disable Lint/EmptyBlock
      end
    end

    describe "each_with_index" do
      it "responds correctly" do
        md = MdArray::MdArray.new([3, 3, 3]) { |z, y, x| [z, y, x] }
        expect(md.each_with_index).to match_array [[[0, 0, 0], [0, 0, 0]], [[0, 0, 1], [0, 0, 1]], [[0, 0, 2], [0, 0, 2]],
                                                   [[0, 1, 0], [0, 1, 0]], [[0, 1, 1], [0, 1, 1]], [[0, 1, 2], [0, 1, 2]],
                                                   [[0, 2, 0], [0, 2, 0]], [[0, 2, 1], [0, 2, 1]], [[0, 2, 2], [0, 2, 2]],
                                                   [[1, 0, 0], [1, 0, 0]], [[1, 0, 1], [1, 0, 1]], [[1, 0, 2], [1, 0, 2]],
                                                   [[1, 1, 0], [1, 1, 0]], [[1, 1, 1], [1, 1, 1]], [[1, 1, 2], [1, 1, 2]],
                                                   [[1, 2, 0], [1, 2, 0]], [[1, 2, 1], [1, 2, 1]], [[1, 2, 2], [1, 2, 2]],
                                                   [[2, 0, 0], [2, 0, 0]], [[2, 0, 1], [2, 0, 1]], [[2, 0, 2], [2, 0, 2]],
                                                   [[2, 1, 0], [2, 1, 0]], [[2, 1, 1], [2, 1, 1]], [[2, 1, 2], [2, 1, 2]],
                                                   [[2, 2, 0], [2, 2, 0]], [[2, 2, 1], [2, 2, 1]], [[2, 2, 2], [2, 2, 2]]]
      end

      it "returns self if called with block" do
        md = MdArray::MdArray.new([])
        expect(md.each { |_, _| }).to eq md # rubocop:disable Lint/EmptyBlock
      end
    end
  end
end
