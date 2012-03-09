module Hashbang
  module Railtie
    class Middleware
      def initialize(application)
        @application = application
        Headless.new.start
      end

      def call(environment)
        if environment['QUERY_STRING'].include? "_escaped_fragment_"
          url  = Crawler.urlFromRack(environment)
          html = Crawler.gimme url

          [200, {"Content-Type" => "text/html; charset=utf-8"}, [html]]
        else
          @application.call(environment)
        end
      end
    end
  end
end