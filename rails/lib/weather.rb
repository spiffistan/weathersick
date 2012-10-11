module Weather

  class << self
    def config
      yield self
    end
  end
end
