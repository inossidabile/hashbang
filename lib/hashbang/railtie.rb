module Hashbang
  class Railtie < Rails::Railtie
    config.hashbang = ActiveSupport::OrderedOptions.new

    config.hashbang.pool_size = 1
    config.hashbang.waiter    = false

    waiters = {
      :joosy => -> b { b.execute_script("return Joosy.Application.loading") == false }
    }

    initializer "application_controller.initialize_hashbang" do |app|
      if app.config.hashbang.waiter.is_a? Symbol
        app.config.hashbang.waiter = waiters[app.config.hashbang.waiter]
      end

      app.config.middleware.use "Hashbang::Middleware", app.config.hashbang
    end
  end
end