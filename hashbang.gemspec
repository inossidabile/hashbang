Gem::Specification.new do |s|
  s.name        = "hashbang"
  s.version     = "0.0.1.alpha"
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Magic support of Google/Bing/... AJAX search indexing for your Rails apps"
  s.email       = "boris@roundlake.ru"
  s.homepage    = "http://roundlake.github.com/hashbang/"
  s.description = "Hashbang is a tiny Rack proxy serving HTML dumps for your RICH web-applications according to Google AJAX Crawling conventions. Make your Rails AJAX applications indexable in no time."
  s.authors     = ['Boris Staal']

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'sys-uname'
  s.add_dependency 'watir-webdriver'
  s.add_dependency 'headless'
  s.add_dependency 'unicorn'
end
