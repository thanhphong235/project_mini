# config/initializers/seed_on_start.rb

# Skip khi đang precompile assets
unless ENV["RUNNING_ASSET_PRECOMPILE"]
  Rails.application.reloader.to_prepare do
    if Rails.env.production?
      # Kiểm tra bảng tồn tại trước khi dùng model
      if ActiveRecord::Base.connection.data_source_exists?('food_drinks') && FoodDrink.count == 0
        puts "🚀 Seed database production tự động..."
        load Rails.root.join("db/seeds.rb")
        puts "✅ Seed hoàn tất!"
      end
    end
  end
end
