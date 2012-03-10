# Bang. Hashbang.

Hashbang is a tiny Rack proxy serving HTML dumps for your RICH web-applications according to 
[Google AJAX Crawling conventions](http://code.google.com/web/ajaxcrawling/). Make your Rails AJAX applications indexable in no time.

Using Rails generators Hashbang will setup small inner Rack application which will handle all magic requests containing `_escaped_fragment_` parameter. These requests will cause a subrequest to a real AJAX URL using virtual browser. 

Let's say for example you've got a request to `test.com/?_escaped_fragment_=/my_hidden_page`. Hashbang will convert this URL to `test.com/#!/my_hidden_page` and open it in a virtual browser. Virtual browser will load this page and wait for `Suncscraper.finish` javascript call. As soon as it was called Hashbang will respond with HTML dump.

Hashbang uses [Sunscraper](http://github.com/roundlake/sunscraper) and therefore you will need Qt to use it.

## Environments are specific

While working at development environment, this gem will catch all the requests containing `_escaped_fragment_` directly from Rails using middleware and therefore it will just work **(see P.S. below)**. Go to `http://localhost:3000?_escaped_fragment_=test` to make Hashbang load and dump `http://localhost:3000/#!/test` for you.

However due to security and performance reasons, at the production servers you are supposed to boot this Rack app separately and manually forward all magic requests to standalone instance.

Imagine you are runing Hasbang rack instance at `33222` port. With that you should proxy all requests containing `_escaped_fragment_=` to `localhost:33222/?url=…` where `…` is full request URI. **Don't forget to escape url parameter so resulting request could like this:** `localhost:33222/?url=http%3A%2F%2Fwww.dvnts.ru%2F%3F_encoded_fragment_%3D`.

You are supposed to limit concurent connections and restrict direct connection to Hashbang instances. We'll describe typical production nginx/passenger setup later in this README.

**P.S.**

Since in most cases basic development setup uses just one Rails instance all the requests to magic urls will lead to Deadlock! To solve this problem we've included the `rake hashbang:rails` command which will run your Rails project inside a [Unicorn](http://unicorn.bogomips.org/) with 2 instances.

You can either simulate production mode runing `rake hashbang:standalone`.

## Installation

Start from your Gemfile:

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
  c.url     = /^$/
  c.timeout = 5000
end
```

#### Url

Limits hashbang crawling to described set of URLs. Limit only works in standalone mode.

#### Timeout

Timeout in miliseconds hashbang will give virtual browser to grab data. Keep it as low as possible. Timeout only works in standalone mode.

## Crawling marker

To help Sunscraper (virtual browser of Hashbang) understand what should be considererd a loaded page, add Javascript `Suncscraper.finish()` call when all AJAX is done and your DOM is ready. Note that for straight client calls `Sunscraper` variable will be empty and therefore you should check if it's available. This is how it should basically look:

```javascript
if (typeof Sunscraper !== "undefined") { Sunscraper.finish() }
```

## Memory consumption

Hashbang will keep one instance of Sunscraper per each instance. Sunscraper  bundles clear QTWebKit and therefore keeps memory consumption as low as possible for virtual browsers. However it can still be noticeable and therefore you should only increase possible concurency if your resource gets indexed often.