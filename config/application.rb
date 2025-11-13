module FoodsDrinksApp
  class Application < Rails::Application
    config.load_defaults 7.1
    config.time_zone = "Hanoi"
    config.active_record.default_timezone = :local

    config.autoload_lib(ignore: %w(assets tasks))

    # ⚙️ Auto-run db:seed on first boot (only if empty)
    config.after_initialize do
      if FoodDrink.count.zero?
        Rails.logger.info "⚙️ Auto running db:seed (no FoodDrink data found)"
        Rails.application.load_seed
      end
    end
  end
end
