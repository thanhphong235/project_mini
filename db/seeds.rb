# db/seeds.rb

puts "⚡ Cleaning old data..."
OrderItem.destroy_all
Order.destroy_all
Rating.destroy_all
FoodDrink.destroy_all
Category.destroy_all
User.where.not(email: ["admin@example.com", "user@example.com"]).destroy_all

puts "✅ Old data cleaned."

# ----------------------------
# Users
# ----------------------------
admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Admin User"
  u.password = "123456"
  u.role = "admin"
end

user = User.find_or_create_by!(email: "user@example.com") do |u|
  u.name = "Test User"
  u.password = "123456"
  u.role = "user"
end

# ----------------------------
# Categories
# ----------------------------
cat_food = Category.find_or_create_by!(name: "Food")
cat_drink = Category.find_or_create_by!(name: "Drink")

# ----------------------------
# Food & Drinks
# ----------------------------
fd1 = FoodDrink.find_or_create_by!(name: "Pizza") do |fd|
  fd.price = 100_000
  fd.category = cat_food
  fd.stock = 10
end

fd2 = FoodDrink.find_or_create_by!(name: "Coffee") do |fd|
  fd.price = 30_000
  fd.category = cat_drink
  fd.stock = 20
end

fd3 = FoodDrink.find_or_create_by!(name: "Burger") do |fd|
  fd.price = 80_000
  fd.category = cat_food
  fd.stock = 15
end

fd4 = FoodDrink.find_or_create_by!(name: "Tea") do |fd|
  fd.price = 20_000
  fd.category = cat_drink
  fd.stock = 25
end

# ----------------------------
# Orders
# ----------------------------
# Enum status: pending, completed, cancelled
order1 = Order.find_or_create_by!(user: user, status: :pending, total_price: fd1.price + fd2.price)
order2 = Order.find_or_create_by!(user: user, status: :completed, total_price: fd3.price + fd4.price)

# ----------------------------
# Order Items
# ----------------------------
OrderItem.find_or_create_by!(order: order1, food_drink: fd1) do |oi|
  oi.quantity = 1
  oi.price = fd1.price
end

OrderItem.find_or_create_by!(order: order1, food_drink: fd2) do |oi|
  oi.quantity = 1
  oi.price = fd2.price
end

OrderItem.find_or_create_by!(order: order2, food_drink: fd3) do |oi|
  oi.quantity = 1
  oi.price = fd3.price
end

OrderItem.find_or_create_by!(order: order2, food_drink: fd4) do |oi|
  oi.quantity = 1
  oi.price = fd4.price
end

# ----------------------------
# Ratings
# ----------------------------
ratings_data = [
  { food_drink: fd1, user: user, score: 5, comment: "Pizza ngon tuyệt vời!" },
  { food_drink: fd1, user: admin, score: 4, comment: "Pizza ổn, nhưng có thể nhiều phô mai hơn." },
  { food_drink: fd2, user: user, score: 4, comment: "Cà phê thơm, ngon." },
  { food_drink: fd2, user: admin, score: 3, comment: "Cà phê ổn, nhưng hơi đắng." },
  { food_drink: fd3, user: user, score: 5, comment: "Burger mềm, thịt chất lượng." },
  { food_drink: fd3, user: admin, score: 4, comment: "Burger ngon, nhưng hơi ít sốt." },
  { food_drink: fd4, user: user, score: 3, comment: "Trà bình thường, dễ uống." },
  { food_drink: fd4, user: admin, score: 4, comment: "Trà ngon, thích vị thanh nhẹ." }
]

ratings_data.each do |data|
  Rating.find_or_create_by!(food_drink: data[:food_drink], user: data[:user]) do |r|
    r.score = data[:score]
    r.comment = data[:comment]
  end
end

puts "✅ Seed completed: Users, Categories, FoodDrinks, Orders, OrderItems, Ratings"
