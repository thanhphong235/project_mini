# config/initializers/seed_on_start.rb

# ❌ Không chạy khi đang precompile assets (Docker)
if ENV["RUNNING_ASSET_PRECOMPILE"] == "1"
  return
end

Rails.application.reloader.to_prepare do
  # Chỉ chạy trong môi trường production thực sự
  next unless Rails.env.production?

  # Kiểm tra bảng có tồn tại trước khi đụng tới model
  if ActiveRecord::Base.connection.data_source_exists?("food_drinks")
    begin
      if FoodDrink.count == 0
        puts "🚀 Đang seed dữ liệu production..."
        load Rails.root.join("db/seeds.rb")
        puts "✅ Seed hoàn tất!"
      end
    rescue NameError
      # Nếu model chưa load hoặc đổi tên → không crash
      puts "⚠️ Model FoodDrink không tồn tại, bỏ qua auto-seed."
    end
  end
end
