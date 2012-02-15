namespace :hashbang do

  desc "Start development unicorn"
  task :rails do
    config = "#{Dir.getwd}/hashbang/unicorn.rb"

    unless File.exists? config
      raise "Hashbang subdirectory does not seem to exist. Did you run `rails g hashbang`?"
    end

    sh "bundle exec unicorn --config-file #{config}"
  end

  desc "Start production standaloner"
  task :standalone do
    rackup = "#{Dir.getwd}/hashbang/config.ru"

    unless File.exists? rackup
      raise "Hashbang subdirectory does not seem to exist. Did you run `rails g hashbang`?"
    end

    sh "bundle exec rackup #{rackup}"
  end
end