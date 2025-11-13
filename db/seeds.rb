# db/seeds.rb
# frozen_string_literal: true

puts "🚀 Seed database bắt đầu..."

# ----------------------------
# Admin test
# ----------------------------
admin_email = "admin_test@example.com"
admin_password = "123456"

admin = User.find_or_initialize_by(email: admin_email)
if admin.new_record?
  admin.name = "Admin Test"
  admin.role = "admin"
  admin.password = admin_password
  admin.password_confirmation = admin_password
  admin.confirmed_at = Time.current if admin.respond_to?(:confirmed_at)
  admin.save!
  puts "✅ Admin test mới tạo thành công!"
else
  admin.password = admin_password
  admin.password_confirmation = admin_password
  admin.save!
  puts "⚠️ Admin test đã tồn tại. Password đã reset!"
end

# ----------------------------
# User test
# ----------------------------
user = User.where.not(id: admin.id).first
unless user
  user = User.create!(
    name: "Normal User",
    email: "user_for_seed@example.com",
    password: "123456",
    password_confirmation: "123456",
    role: "user",
    confirmed_at: Time.current
  )
  puts "✅ User test tạo thành công!"
end

# ----------------------------
# Categories
# ----------------------------
cat_food  = Category.find_or_create_by!(name: "Food")
cat_drink = Category.find_or_create_by!(name: "Drink")
puts "✅ Categories đã có sẵn: #{Category.pluck(:name).join(', ')}"

# ----------------------------
# Món mặc định
# ----------------------------
default_foods_drinks = [
  { name: "Pizza",  price: 100_000, category: cat_food,  stock: 10 },
  { name: "Burger", price: 80_000,  category: cat_food,  stock: 15 },
  { name: "Coffee", price: 30_000,  category: cat_drink, stock: 20 },
  { name: "Tea",    price: 20_000,  category: cat_drink, stock: 25 }
]

default_foods_drinks.each do |fd_data|
  fd = FoodDrink.find_or_initialize_by(name: fd_data[:name])
  fd.update!(
    price: fd_data[:price],
    category: fd_data[:category],
    stock: fd_data[:stock],
    description: "Món #{fd_data[:name]} – hương vị hấp dẫn, phù hợp mọi khẩu vị."
  )
end
puts "✅ Món mặc định đã seed xong"

# ----------------------------
# 10 Món ăn thử nghiệm với rating
# ----------------------------
categories = [cat_food, cat_drink]

10.times do |i|
  fd = FoodDrink.create!(
    name: "Món thử #{i + 1}",
    price: rand(20000..150000),
    category: categories.sample,
    stock: rand(0..20),
    description: "Món thử #{i + 1} – hương vị hấp dẫn, phù hợp mọi khẩu vị."
  )

  # Tạo ratings ngẫu nhiên
  users_for_rating = [user, admin]
  rand(3..6).times do
    Rating.create!(
      food_drink: fd,
      user: users_for_rating.sample,
      score: rand(1.0..5.0).round(1),
      comment: ["Ngon!", "Hơi nhạt", "Rất ngon", "Thử lại lần sau", "Tuyệt vời", "Ổn"].sample
    )
  end
end
puts "✅ Seed 10 món thử nghiệm với rating"

# ----------------------------
# Orders và Order Items
# ----------------------------
fd_pizza  = FoodDrink.find_by(name: "Pizza")
fd_burger = FoodDrink.find_by(name: "Burger")
fd_coffee = FoodDrink.find_by(name: "Coffee")
fd_tea    = FoodDrink.find_by(name: "Tea")

order1 = Order.find_or_initialize_by(user: user, status: :pending)
order1.update!(total_price: fd_pizza.price + fd_coffee.price)

order2 = Order.find_or_initialize_by(user: user, status: :completed)
order2.update!(total_price: fd_burger.price + fd_tea.price)

[
  { order: order1, food_drink: fd_pizza, quantity: 1 },
  { order: order1, food_drink: fd_coffee, quantity: 1 },
  { order: order2, food_drink: fd_burger, quantity: 1 },
  { order: order2, food_drink: fd_tea, quantity: 1 }
].each do |oi_data|
  oi = OrderItem.find_or_initialize_by(order: oi_data[:order], food_drink: oi_data[:food_drink])
  oi.update!(quantity: oi_data[:quantity], price: oi_data[:food_drink].price)
end
puts "✅ Orders và OrderItems seed xong"

# ----------------------------
# Ratings cho món mặc định
# ----------------------------
ratings_data = [
  { food_drink: fd_pizza,  user: user,  score: 5, comment: "Pizza ngon tuyệt vời!" },
  { food_drink: fd_pizza,  user: admin, score: 4, comment: "Pizza ổn, có thể thêm phô mai." },
  { food_drink: fd_coffee, user: user,  score: 4, comment: "Cà phê thơm, ngon." },
  { food_drink: fd_coffee, user: admin, score: 3, comment: "Cà phê hơi đắng." },
  { food_drink: fd_burger, user: user,  score: 5, comment: "Burger mềm, thịt ngon." },
  { food_drink: fd_burger, user: admin, score: 4, comment: "Burger ngon, hơi ít sốt." },
  { food_drink: fd_tea,    user: user,  score: 3, comment: "Trà bình thường." },
  { food_drink: fd_tea,    user: admin, score: 4, comment: "Trà ngon, vị thanh nhẹ." }
]

ratings_data.each do |data|
  r = Rating.find_or_initialize_by(food_drink: data[:food_drink], user: data[:user])
  r.update!(score: data[:score], comment: data[:comment])
end
puts "✅ Ratings cho món mặc định seed xong"

puts "--------------------------------------------"
puts "👨‍💻 Admin test account:"
puts "   Email: #{admin.email}"
puts "   Password: #{admin_password}"
puts "--------------------------------------------"
puts "🚀 Seed database hoàn tất!"
