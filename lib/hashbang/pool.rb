module Hashbang
  class Pool
    cattr_accessor :inited
    cattr_accessor :pool_size
    cattr_accessor :browsers
    cattr_accessor :taken

    def self.setup(quantity=1)
      @@pool_size = quantity

      self.init if !Rails || Rails.env != 'development'
    end

    def self.init
      @@browsers = []
      @@taken    = []

      @@pool_size.times do
        @@browsers << browser = Watir::Browser.new
        at_exit { browser.close if browser.exists? }
      end

      @@inited = true
    end

    def self.grab
      self.init unless @@inited

      raise "Pool is empty" if @@browsers.length == 0

      @@taken << browser = @@browsers.pop
      browser
    end

    def self.release(browser)
      @@taken.delete browser
      @@browsers << browser
    end
  end
end