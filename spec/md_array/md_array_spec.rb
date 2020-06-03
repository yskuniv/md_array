RSpec.describe MdArray do
  describe MdArray do
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
      where(:size, :answer) do
        [
          [[], 0],
          [[1], 1],
          [[1, 1], 2]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new(size)
          expect(md.dimension).to eq answer
        end
      end
    end

    describe "[]" do
      where(:index, :answer) do
        [
          [[0, 0, 0], [0, 0, 0]],
          [[1, 1, 1], [1, 1, 1]],
          [[2, 2, 2], [2, 2, 2]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([3, 3, 3]) { |z, y, x| [z, y, x] }
          expect(md[index]).to eq answer
        end
      end
    end

    describe "adjacent" do
      where(:index, :answer) do
        [
          [[0, 0, 0],
           [[0, 0, 1],
            [0, 1, 0],
            [1, 0, 0]]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([4, 4, 4]) { |z, y, x| [z, y, x] }
          expect(md.adjacent(index)).to match_array answer
        end
      end
    end

    describe "neighborhood" do
      where(:index, :answer) do
        [
          [[0, 0, 0],
           [[0, 0, 1],
            [0, 1, 0], [0, 1, 1],
            [1, 0, 0], [1, 0, 1],
            [1, 1, 0], [1, 1, 1]]]
        ]
      end

      with_them do
        it "responds correctly" do
          md = MdArray::MdArray.new([4, 4, 4]) { |z, y, x| [z, y, x] }
          expect(md.neighborhood(index)).to match_array answer
        end
      end
    end
  end
end
