module Hashbang
  class Middleware
    def initialize(application, config)
      @application = application
      @config      = config

      Headless.new.start
      Pool.setup config.pool_size, config.browser
    end

    def call(environment)
      if environment['QUERY_STRING'].include? "_escaped_fragment_"
        url = []
        url << environment['rack.url_scheme'] + '://'
        url << environment['HTTP_HOST']
        url << environment['REQUEST_PATH']
        url << '?' unless environment['QUERY_STRING'].starts_with? '_escaped_fragment_'
        url << environment['QUERY_STRING'].gsub(/(\&)?_escaped_fragment_=/, '#!')
        url = url.join ''

        if @config.waiter
          html = Crawler.gimme(url) do |browser|
            @config.waiter.call(browser)
          end
        else
          html = Crawler.gimme url
        end

        [200, {"Content-Type" => "text/html"}, [html]]
      else
        @application.call(environment)
      end
    end
  end
end