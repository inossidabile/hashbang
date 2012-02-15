module Hashbang
  class Crawler
    def self.gimme(url, &block)
      browser = Pool.grab

      begin
        browser.goto url

        if block_given?
          Watir::Wait.until { block.call browser }
        end

        browser.html
      rescue
      ensure
        Hashbang::Pool.release(browser)
      end
    end
  end
end