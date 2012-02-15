# Bang. Hashbang.

Hashbang will automatically enable serving HTML dumps from your RICH web-applications according to 
[Google AJAX Crawling conventions](http://code.google.com/web/ajaxcrawling/). Make your Rails AJAX applications indexable in no time.

Hashbang will make all incoming requests containing magic `_escaped_fragment_` parameter to be served in a special way. This case will cause a subrequest to a real AJAX URL using virtual browser. This hidden browser will wait for some condition you define using well-known [Watir](http://watirwebdriver.com/) API. And then return an HTML dump.

Let's say for example you've got a request to `test.com/?_escaped_fragment_=/my_hidden_page`.

Hashbang will convert this URL to `test.com/#!/my_hidden_page` and open it in a virtual browser.

Virtual browser will call your lambda with `browser` object as parameter. With help of this lambda you can setup the wait behavior. Here is a great introduction to [Watir wait API](http://watirwebdriver.com/waiting/). Note that your lambda will act as a block to `Watir::Wait.until`.

## Installation & Example

Start from your Gemfile:

```
  gem 'hashbang'
```
  
Waiter can be defined inside your environments:

```ruby
  config.hashbang.waiter = -> b { b.execute_script("return Joosy.Application.loading") == false }
```

This code will wait for javascript Joosy.Application.loading variable to be set to false.

## Development environment

By its nature Hashbang gem requires your server to accept at least 2 concurrent connections. However WEBRick or Thin (which are mostly used as development servers) will only serve one Rails instance (and connection). That's why if you want to debug your AJAX crawling, you'll have to use `unicorn` with at least 2 workers.

Note either that browser load behavior differs between development and production environments. Hashbang will use lazy load for development and therefore it may take some time for crawler to respond. While running in production environment it will start and cache browser instance at rails startup to provide the best possible response speed.