module Hashbang
  module Crawler
    extend self

    def gimme(url)
      Sunscraper.scrape_url url, 100000
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