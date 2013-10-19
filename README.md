# Bang. Hashbang.

Hashbang is a tiny Rack proxy serving HTML dumps for your RICH web-applications according to 
[Google AJAX Crawling conventions](http://code.google.com/web/ajaxcrawling/). Make your Rails AJAX applications indexable in no time.

Using Rails generators Hashbang will setup a small inner Rack application which will handle all magic requests containing `_escaped_fragment_` parameter. These requests will cause a subrequest to a real AJAX URL using a virtual browser. 

Let's say for example you've got a request to `test.com/?_escaped_fragment_=/my_hidden_page`. Hashbang will convert this URL to `test.com/#!/my_hidden_page` and open it in the virtual browser. The virtual browser will load this page and wait for `Suncscraper.finish` javascript call. As soon as it was called Hashbang will respond with an HTML dump.

Hashbang uses [Sunscraper](http://github.com/inossidabile/sunscraper) and therefore you will need Qt to use it.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/inossidabile/hashbang/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
[![endorse](http://api.coderwall.com/inossidabile/endorsecount.png)](http://coderwall.com/inossidabile)

## Environments are specific

While working with at development environment, this gem will catch all the requests containing `_escaped_fragment_` directly from Rails using middleware and therefore it will just work **(see P.S. below)**. Go to `http://localhost:3000?_escaped_fragment_=test` to make Hashbang load and dump `http://localhost:3000/#!/test` for you.

Due to security and performance reasons, at the production servers you are supposed to boot this Rack app separately and manually forward all the magic requests to the standalone instance.

Imagine you are runing Hashbang rack instance at `33222` port. With that you should proxy all the requests containing `_escaped_fragment_=` to `localhost:33222/?url=…` where `…` is a full request URI. **Don't forget to escape url parameter so resulting request could be like this:** `localhost:33222/?url=http%3A%2F%2Fwww.dvnts.ru%2F%3F_encoded_fragment_%3D`.

You are supposed to limit the concurent connections and restrict the direct connection to Hashbang instances. We'll describe typical production nginx/passenger setup later in this README.

**P.S.**

Since in most cases basic development setup uses just one Rails instance, all the requests to magic urls will lead to Deadlock! To solve this problem we've included the `rake hashbang:rails` command which will run your Rails project inside a [Unicorn](http://unicorn.bogomips.org/) with 2 instances.

You can also simulate production mode runing `rake hashbang:standalone`.

## Installation

Ensure you have the Qt dependencies for Sunscraper (read [Sunscraper description](http://github.com/roundlake/sunscraper/) for more info).

To install it on Mac with [Homebrew](http://mxcl.github.com/homebrew/) run `brew install qt`. 

To install it on Debian run `apt-get install qt4-dev-tools --no-install-recommends`.

Add gem to your Gemfile:

```
gem 'hashbang'
```

And follow with basic generator:

```
rails g hashbang
```

This generator will create an inline Rack application at `hashbang/` dir. You can proceed with required configuration at `hashbang/config.rb`.

## Configuration

```ruby
Hashbang::Config.map do |c|
  c.url     = /^.*$/
  c.timeout = 5000
end
```

#### Url

Url limits hashbang crawling to described set of URLs. The limit only works in standalone mode.

#### Timeout

Hashbang will give virtual browser specified timeout in miliseconds to grab data. Keep it as low as possible. The timeout only works in standalone mode.

## Crawling marker

To help Sunscraper (virtual browser of Hashbang) understand what should be considered a loaded page, add Javascript `Suncscraper.finish()` call when all AJAX is done and your DOM is ready. Note that for the straight client calls `Sunscraper` variable will be empty and therefore you should check if it's available. This is how it should basically look:

```javascript
if (typeof Sunscraper !== "undefined") { Sunscraper.finish() }
```

## Typical production configurations

### Nginx + Passenger

This configuration includes usage of `limit_conn_module` of nginx which is not compiled by default. Please setup it according to [official manual](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html). You can omit `limit_conn` directive but you never should do it since hasbang will always dramaticaly increase your server load. And 5 concurent connections is quite always enough to serve search engine bots.

```
upstream hashbang-dvnts {
  server localhost:22333;
}

server {
  listen 22333;
  server_name localhost;

  location / {
    limit_conn perserver 5;
    root /path/to/project/current/hashbang/public;
    passenger_enabled on;
    access_log /path/to/project/current/log/hashbang.access.log;
    error_log /path/to/project/current/log/hashbang.error.log;
  }
}
```

## Memory consumption

Hashbang will keep one instance of Sunscraper per each Hashbang instance. Sunscraper  bundles clear QTWebKit and therefore keeps memory consumption as low as possible for virtual browsers. However it can still be noticeable and therefore you should only increase possible concurency if your resource gets indexed often.

## Maintainers

* Boris Staal, [@inossidabile](http://staal.io)

## License

It is free software, and may be redistributed under the terms of MIT license.