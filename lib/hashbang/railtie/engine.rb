require 'hashbang/railtie/middleware'

module Hashbang
  module Railtie
    class Engine < Rails::Engine
      initializer "application_controller.initialize_hashbang" do |app|
        if Rails.env == 'development'
          app.config.middleware.use "Hashbang::Railtie::Middleware"
          Config::load Rails.root.join('hashbang/config.rb').to_s
        end
      end

      rake_tasks do
        Dir[File.expand_path('../../tasks/*.rake',  __FILE__)].each { |f| load f }
      end
    end
  end
end