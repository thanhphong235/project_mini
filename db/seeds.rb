# frozen_string_literal: true

puts "🚀 Bắt đầu seed database..."

# ----------------------------
# Users
# ----------------------------
puts "👤 Tạo tài khoản người dùng mặc định..."

admin_email = "admin@example.com"
user_email  = "user@example.com"

# Xóa nếu đã tồn tại để tránh lỗi provider/email
User.where(email: [admin_email, user_email]).destroy_all

admin = User.create!(
  name: "Admin User",
  email: admin_email,
  password: "123456",
  password_confirmation: "123456",
  role: "admin",
  provider: nil,
  uid: nil
)

user = User.create!(
  name: "Normal User",
  email: user_email,
  password: "123456",
  password_confirmation: "123456",
  role: "user",
  provider: nil,
  uid: nil
)

# ----------------------------
# Categories
# ----------------------------
cat_food  = Category.find_or_create_by!(name: "Food")
cat_drink = Category.find_or_create_by!(name: "Drink")

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
    stock: fd_data[:stock]
  )
end

# ----------------------------
# Tạo 50 món ăn & đồ uống ngẫu nhiên
# ----------------------------
food_names = ["Pizza Margherita", "Burger Bò Mỹ", "Spaghetti Carbonara", "Salad Caesar",
              "Sushi Sashimi", "Bún Chả", "Phở Bò", "Cơm Tấm Sườn", "Gà Rán KFC", "Bánh Mì Thịt"]

drink_names = ["Cà Phê Sữa Đá", "Trà Sữa Trân Châu", "Nước Ép Cam", "Sinh Tố Bơ",
               "Matcha Latte", "Coca Cola", "Pepsi", "Trà Xanh", "Bia Sài Gòn", "Nước Khoáng"]

puts "🍽️  Đang tạo 50 món ăn & đồ uống ngẫu nhiên..."
50.times do |i|
  category = [cat_food, cat_drink].sample
  base_name = category == cat_food ? food_names.sample : drink_names.sample
  name = "#{base_name} #{i + 1}"

  fd = FoodDrink.find_or_initialize_by(name: name)
  fd.update!(
    price: rand(15_000..150_000),
    category: category,
    stock: rand(5..50),
    description: "Món #{name} – hương vị hấp dẫn, phù hợp mọi khẩu vị."
  )
end

# ----------------------------
# Orders
# ----------------------------
fd_pizza  = FoodDrink.find_by(name: "Pizza")
fd_burger = FoodDrink.find_by(name: "Burger")
fd_coffee = FoodDrink.find_by(name: "Coffee")
fd_tea    = FoodDrink.find_by(name: "Tea")

order1 = Order.find_or_initialize_by(user: user, status: :pending)
order1.update!(total_price: fd_pizza.price + fd_coffee.price)

order2 = Order.find_or_initialize_by(user: user, status: :completed)
order2.update!(total_price: fd_burger.price + fd_tea.price)

# ----------------------------
# Order Items
# ----------------------------
[
  { order: order1, food_drink: fd_pizza, quantity: 1 },
  { order: order1, food_drink: fd_coffee, quantity: 1 },
  { order: order2, food_drink: fd_burger, quantity: 1 },
  { order: order2, food_drink: fd_tea, quantity: 1 }
].each do |oi_data|
  oi = OrderItem.find_or_initialize_by(order: oi_data[:order], food_drink: oi_data[:food_drink])
  oi.update!(quantity: oi_data[:quantity], price: oi_data[:food_drink].price)
end

# ----------------------------
# Ratings
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

puts "⭐ Seed completed!"
puts "--------------------------------------------"
puts "👨‍💻  Admin account:"
puts "   Email: admin@example.com"
puts "   Password: 123456"
puts "👤  User account:"
puts "   Email: user@example.com"
puts "   Password: 123456"
puts "--------------------------------------------"
