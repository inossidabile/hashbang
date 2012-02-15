Gem::Specification.new do |s|
  s.name        = "hashbang"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Magic support of Google/Bing/... AJAX search indexing for your Rails apps"
  s.email       = "boris@roundlake.ru"
  s.homepage    = "http://roundlake.github.com/hashbang/"
  s.description = "TODO"
  s.authors     = ['Boris Staal']

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'watir-webdriver'
  s.add_dependency 'headless'
end
