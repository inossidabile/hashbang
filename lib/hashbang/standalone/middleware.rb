require 'uri'

# coding: utf-8
module Hashbang
  module Standalone
    class Middleware
      def initialize(root)
        Config.load File.expand_path('config.rb', root)
        Headless.new.start
      end

      def call(environment)
        url = environment['QUERY_STRING'].split('&').find{|x| x[0,4] == 'url='}

        unless url.to_s.length == 0
          url = url.split('=')
          url.shift

          url = url.join('=')
          url = URI.unescape url
          url = Crawler.urlFromUrl url
        end

        host = URI.parse(url).host

        if url.to_s.length == 0 || !host.match(Config.url)
          return [200, {"Content-Type" => "text/html; charset=utf-8"}, ['']]
        end

        html = Crawler.gimme url, Config.timeout

        if html.respond_to? :force_encoding
          html.force_encoding "UTF-8"
        end

        return [200, {"Content-Type" => "text/html; charset=utf-8"}, [html]]
      end
    end
  end
end