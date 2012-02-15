# Bang. Hashbang.

Hashbang is a tiny Rack proxy serving HTML dumps for your RICH web-applications according to 
[Google AJAX Crawling conventions](http://code.google.com/web/ajaxcrawling/). Make your Rails AJAX applications indexable in no time.

Using Rails generators Hashbang will setup small inner Rack application which will handle all magic requests containing `_escaped_fragment_` parameter. These requests will cause a subrequest to a real AJAX URL using virtual browser. This hidden browser will wait for some condition you define using well-known [Watir](http://watirwebdriver.com/) API. And then return an HTML dump.

Let's say for example you've got a request to `test.com/?_escaped_fragment_=/my_hidden_page`.

Hashbang will convert this URL to `test.com/#!/my_hidden_page` and open it in a virtual browser.

Virtual browser will call your lambda with `browser` object as parameter. With help of this lambda you can setup the wait behavior. Here is a great introduction to [Watir wait API](http://watirwebdriver.com/waiting/). Note that your lambda will act as a block to `Watir::Wait.until`.

## Installation

Start from your Gemfile:

```
gem 'hashbang'
```

And follow with basic generator:

```
rails g hashbang
```

This generator will create an inline Rack application at `hashbang/` dir. To set lambda you want to use to check if your page is ready refer to `hashbang/config.rb`.

## Environments are specific

While working at development environment, this gem will catch all the requests directly from rails using middleware and therefore it will just work (see P.S. below :). However due to security and performance reasons, at the production servers you are supposed to boot this Rack app separately and manually forward all magic requests to it. We'll describe typical production nginx/passenger setup later in this README.

P.S. Since basic development setup will use just one Rails instance in most cases all the requests to magic urls will lead to Deadlock! To solve this problem we've included the `rake hashbang:rails` command which will run your Rails project inside a [Unicorn](http://unicorn.bogomips.org/) with 2 instances.

## Memory consumption

This part of hashbang is currently in progress. We still bundle Watir chromedev for proof-of-concept reasons. The full version will come with Qt WebKit bindings.