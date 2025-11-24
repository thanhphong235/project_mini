# Chỉ chạy trên production và khi database trống
if Rails.env.production? && FoodDrink.count == 0
  puts "🚀 Seed database production tự động..."
  load Rails.root.join("db/seeds.rb")
  puts "✅ Seed hoàn tất!"
end
