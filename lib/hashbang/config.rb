module Hashbang
  module Config
    extend self

    def map
      yield self
    end

    def load(path)
      if File.exists? path
        require path
      end
    end
  end
end