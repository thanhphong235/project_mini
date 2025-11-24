# config/initializers/seed_on_start.rb

# Chỉ chạy trên production và khi app khởi động bình thường
# Không chạy khi precompile assets
unless ENV["RUNNING_ASSET_PRECOMPILE"]
  if Rails.env.production?
    # Kiểm tra bảng đã tồn tại chưa
    if ActiveRecord::Base.connection.data_source_exists?('food_drinks') && FoodDrink.count == 0
      puts "🚀 Seed database production tự động..."
      load Rails.root.join("db/seeds.rb")
      puts "✅ Seed hoàn tất!"
    end
  end
end
