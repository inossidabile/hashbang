module Hashbang
  module Config
    extend self

    attr_accessor :waiter

    def waiters
      {
        :joosy => -> b { b.execute_script("return Joosy.Application.loading") == false }
      }
    end

    def map
      self.waiter = false

      yield self

      if self.waiter.is_a? Symbol
        self.waiter = self.waiters[self.waiter]
      end
    end

    def load(path)
      if File.exists? path
        require path
      end
    end
  end
end