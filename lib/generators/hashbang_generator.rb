class HashbangGenerator < Rails::Generators::Base
  source_root File.join(File.dirname(__FILE__), 'templates')

  def create_files
    empty_directory "hashbang"
    template "config.ru", "hashbang/config.ru"
    template "config.rb", "hashbang/config.rb"
    template "unicorn.rb", "hashbang/unicorn.rb"

    empty_directory "hashbang/tmp"
    create_file "hashbang/tmp/.gitkeep"

    empty_directory "hashbang/public"
    create_file "hashbang/public/.gitkeep"
  end
end