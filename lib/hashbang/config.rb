module Hashbang
  module Config
    attr_accessor :url, :timeout

    extend self

    def map
      yield self
    end

    def load(path)
      if File.exists? path
        require path
      end

      self.url = /^#{url}/ unless self.url.is_a? Regexp
    end
  end
end