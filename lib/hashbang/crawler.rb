module Hashbang
  module Crawler
    extend self

    @@browser = false

    def setup
      @@browser = Watir::Browser.new(:chrome)
      at_exit { @@browser.close if @@browser.exists? }
    end

    def gimme(url, proc=false, &block)
      self.setup if !@@browser

      begin
        @@browser.goto url

        if proc
          Watir::Wait.until { proc.call @@browser }
        elsif block_given?
          Watir::Wait.until { block.call @@browser }
        end

        @@browser.html
      rescue
        ''
      end
    end

    def urlFromRack(environment)
      url = []
      url << environment['rack.url_scheme'] + '://'
      url << environment['HTTP_HOST']
      url << environment['REQUEST_PATH']
      url << '?' unless environment['QUERY_STRING'].starts_with? '_escaped_fragment_'
      url << environment['QUERY_STRING'].gsub(/(\&)?_escaped_fragment_=/, '#!')

      url.join ''
    end

    def urlFromUrl(url)
      url.gsub(/[\?\&]_escaped_fragment_=/, '#!')
    end
  end
end