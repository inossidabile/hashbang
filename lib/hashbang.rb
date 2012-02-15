require 'headless'
require 'watir-webdriver'
require 'sys/uname'

require 'hashbang/crawler'
require 'hashbang/config'
require 'hashbang/railtie/engine' if defined? Rails

# Mapping chromedrive
if Sys::Uname.sysname == 'Darwin'
  platform = 'mac'
else
  raise "Your platform is not supported"
end

platform = File.dirname(__FILE__) + "/../bin/#{platform}/chromedriver"
Selenium::WebDriver::Chrome::Service.executable_path = platform