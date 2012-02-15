# coding: utf-8
module Hashbang
  module Standalone
    class Middleware
      def initialize(root)
        Config.load File.expand_path('config.rb', root)

        Headless.new.start
        Crawler::setup
      end

      def call(environment)
        url = environment['QUERY_STRING'].split('&').find{|x| x[0,4] == 'url='}

        if url.to_s.length == 0
          return [200, {"Content-Type" => "text/html; charset=utf-8"}, ['']]
        end

        url  = url.split('=')[1]
        url  = Crawler.urlFromUrl(url)
        html = Crawler.gimme url, Config.waiter

        if html.respond_to? :force_encoding
          html.force_encoding "UTF-8"
        end

        return [200, {"Content-Type" => "text/html; charset=utf-8"}, [html]]
      end
    end
  end
end