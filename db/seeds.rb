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
# Categories
# ----------------------------
cat_food  = Category.find_or_create_by!(name: "Food")
cat_drink = Category.find_or_create_by!(name: "Drink")

# ----------------------------
# Món mặc định (thêm đầy đủ)
# ----------------------------
default_foods_drinks = [
  { name: "Pizza",  price: 100_000, category: cat_food,  stock: 10 },
  { name: "Burger", price: 80_000,  category: cat_food,  stock: 15 },
  { name: "Coffee", price: 30_000,  category: cat_drink, stock: 20 },
  { name: "Tea",    price: 20_000,  category: cat_drink, stock: 25 },
  { name: "Spaghetti Bolognese", price: 90_000, category: cat_food, stock: 12 },
  { name: "Fried Chicken", price: 70_000, category: cat_food, stock: 18 },
  { name: "Orange Juice", price: 25_000, category: cat_drink, stock: 30 },
  { name: "Lemonade", price: 22_000, category: cat_drink, stock: 28 },
  { name: "Ice Cream", price: 35_000, category: cat_food, stock: 16 },
  { name: "Smoothie", price: 40_000, category: cat_drink, stock: 22 },
  { name: "Steak", price: 150_000, category: cat_food, stock: 8 },
  { name: "Sushi", price: 120_000, category: cat_food, stock: 10 },
  { name: "Latte", price: 45_000, category: cat_drink, stock: 20 },
  { name: "Mocha", price: 50_000, category: cat_drink, stock: 20 }
]

default_foods_drinks.each do |fd_data|
  fd = FoodDrink.find_or_initialize_by(name: fd_data[:name])
  fd.update!(
    price: fd_data[:price],
    category: fd_data[:category],
    stock: fd_data[:stock],
    description: "Món #{fd_data[:name]} – hương vị đặc trưng, được yêu thích bởi nhiều khách hàng."
  )
end

# ----------------------------
# Orders và Order Items
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
end

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

# ----------------------------
# Ratings cho tất cả món
# ----------------------------
foods_for_ratings = FoodDrink.all
ratings_data = []

foods_for_ratings.each do |fd|
  case fd.name
  when "Pizza"
    ratings_data << { food_drink: fd, user: user, score: 5, comment: "Pizza ngon tuyệt vời!" }
    ratings_data << { food_drink: fd, user: admin, score: 4, comment: "Pizza ổn, có thể thêm phô mai." }
  when "Burger"
    ratings_data << { food_drink: fd, user: user, score: 5, comment: "Burger mềm, thịt ngon." }
    ratings_data << { food_drink: fd, user: admin, score: 4, comment: "Burger ngon, hơi ít sốt." }
  when "Coffee"
    ratings_data << { food_drink: fd, user: user, score: 4, comment: "Cà phê thơm, ngon." }
    ratings_data << { food_drink: fd, user: admin, score: 3, comment: "Cà phê hơi đắng." }
  when "Tea"
    ratings_data << { food_drink: fd, user: user, score: 3, comment: "Trà bình thường." }
    ratings_data << { food_drink: fd, user: admin, score: 4, comment: "Trà ngon, vị thanh nhẹ." }
  when "Spaghetti Bolognese"
    ratings_data << { food_drink: fd, user: user, score: 5, comment: "Mì Ý sốt bò bằm chuẩn vị!" }
    ratings_data << { food_drink: fd, user: admin, score: 4, comment: "Ngon, hơi nhiều sốt." }
  when "Fried Chicken"
    ratings_data << { food_drink: fd, user: user, score: 4, comment: "Gà giòn, thơm ngon!" }
    ratings_data << { food_drink: fd, user: admin, score: 5, comment: "Tuyệt vời, giòn rụm!" }
  when "Orange Juice"
    ratings_data << { food_drink: fd, user: user, score: 5, comment: "Nước cam tươi mát!" }
    ratings_data << { food_drink: fd, user: admin, score: 4, comment: "Vị ngon, hơi ngọt." }
  when "Lemonade"
    ratings_data << { food_drink: fd, user: user, score: 4, comment: "Chanh mát lạnh, rất ngon." }
    ratings_data << { food_drink: fd, user: admin, score: 4, comment: "Ổn, vị chua dịu nhẹ." }
  when "Ice Cream"
    ratings_data << { food_drink: fd, user: user, score: 5, comment: "Kem béo, ngọt vừa phải!" }
    ratings_data << { food_drink: fd, user: admin, score: 5, comment: "Rất ngon, mát lạnh!" }
  when "Smoothie"
    ratings_data << { food_drink: fd, user: user, score: 5, comment: "Sinh tố trái cây tươi ngon!" }
    ratings_data << { food_drink: fd, user: admin, score: 4, comment: "Ngon, nên giảm đá chút." }
  when "Steak"
    ratings_data << { food_drink: fd, user: user, score: 5, comment: "Bò nướng mềm, sốt đậm đà!" }
    ratings_data << { food_drink: fd, user: admin, score: 5, comment: "Đỉnh cao của món chính!" }
  when "Sushi"
    ratings_data << { food_drink: fd, user: user, score: 5, comment: "Sushi tươi ngon, chuẩn Nhật!" }
    ratings_data << { food_drink: fd, user: admin, score: 4, comment: "Ngon, nhưng cơm hơi nhiều." }
  when "Latte"
    ratings_data << { food_drink: fd, user: user, score: 4, comment: "Latte thơm, sữa béo!" }
    ratings_data << { food_drink: fd, user: admin, score: 4, comment: "Ổn, lớp bọt đẹp." }
  when "Mocha"
    ratings_data << { food_drink: fd, user: user, score: 5, comment: "Mocha ngọt dịu, thơm cacao!" }
    ratings_data << { food_drink: fd, user: admin, score: 5, comment: "Rất ngon, hương vị tuyệt!" }
  end
end

ratings_data.each do |data|
  rating = Rating.find_or_initialize_by(food_drink: data[:food_drink], user: data[:user])
  rating.update!(score: data[:score], comment: data[:comment])
end

puts "✅ Seed database hoàn tất!"
puts "--------------------------------------------"
puts "👨‍💻 Admin test account:"
puts "   Email: #{admin.email}"
puts "   Password: #{admin_password}"
puts "--------------------------------------------"
