module Utils
  class << self
    def partial(f, *args)
      proc { |*extra_args| f.call(*(args + extra_args)) }
    end
  end
end
