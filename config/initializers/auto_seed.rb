# config/initializers/auto_seed.rb
if Rails.env.production? && FoodDrink.count.zero?
  puts "🌱 Auto-seed production database..."

  # ----------------------------
  # Users
  # ----------------------------
  admin = User.find_or_create_by!(email: "admin_test@example.com") do |u|
    u.name = "Admin Test"
    u.role = "admin"
    u.password = "123456"
    u.password_confirmation = "123456"
    u.confirmed_at = Time.current if u.respond_to?(:confirmed_at)
  end

  user = User.where.not(id: admin.id).first
  unless user
    user = User.create!(
      name: "Normal User",
      email: "user@example.com",
      password: "123456",
      password_confirmation: "123456",
      role: "user",
      confirmed_at: Time.current
    )
  end

  # ----------------------------
  # Categories
  # ----------------------------
  cat_food  = Category.find_or_create_by!(name: "Food")
  cat_drink = Category.find_or_create_by!(name: "Drink")

  # ----------------------------
  # 10 món ăn & thức uống
  # ----------------------------
  foods = [
    ["Pizza", 100_000, cat_food, 10],
    ["Burger", 80_000, cat_food, 15],
    ["Coffee", 30_000, cat_drink, 20],
    ["Tea", 20_000, cat_drink, 25],
    ["Spaghetti", 90_000, cat_food, 10],
    ["Sushi", 120_000, cat_food, 8],
    ["Bánh mì kẹp", 50_000, cat_food, 15],
    ["Nước cam", 25_000, cat_drink, 20],
    ["Sinh tố dâu", 40_000, cat_drink, 18],
    ["Trà sữa", 35_000, cat_drink, 25]
  ]

  foods.each do |name, price, category, stock|
    fd = FoodDrink.find_or_create_by!(name: name)
    fd.update!(
      price: price,
      category: category,
      stock: stock,
      description: "Món #{name} – hương vị hấp dẫn, phù hợp mọi khẩu vị."
    )
  end

  # ----------------------------
  # Ratings mặc định (user + admin)
  # ----------------------------
  ratings_data = [
    { name: "Pizza", score_user: 5, score_admin: 4 },
    { name: "Burger", score_user: 5, score_admin: 4 },
    { name: "Coffee", score_user: 4, score_admin: 3 },
    { name: "Tea", score_user: 3, score_admin: 4 },
    { name: "Spaghetti", score_user: 4, score_admin: 4 },
    { name: "Sushi", score_user: 5, score_admin: 4 },
    { name: "Bánh mì kẹp", score_user: 4, score_admin: 3 },
    { name: "Nước cam", score_user: 3, score_admin: 3 },
    { name: "Sinh tố dâu", score_user: 4, score_admin: 4 },
    { name: "Trà sữa", score_user: 5, score_admin: 4 }
  ]

  ratings_data.each do |data|
    fd = FoodDrink.find_by(name: data[:name])
    Rating.find_or_create_by!(food_drink: fd, user: user) do |r|
      r.score = data[:score_user]
      r.comment = "Đánh giá của user cho #{fd.name}"
    end
    Rating.find_or_create_by!(food_drink: fd, user: admin) do |r|
      r.score = data[:score_admin]
      r.comment = "Đánh giá của admin cho #{fd.name}"
    end
  end

  puts "✅ Auto-seed production database hoàn tất!"
end
