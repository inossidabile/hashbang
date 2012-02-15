class HashbangGenerator < Rails::Generators::Base
  source_root File.join(File.dirname(__FILE__), 'templates')

  def create_files
    empty_directory "hashbang"
    template "config.ru", "hashbang/config.ru"
    template "unicorn.rb", "hashbang/unicorn.rb"
  end
end