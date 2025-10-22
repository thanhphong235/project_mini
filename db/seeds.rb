# ----------------------------
# Users
# ----------------------------
user = User.find_or_create_by!(email: "user@example.com") do |u|
  u.name = "Test User"
  u.password = "123456"
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
  fd.price = 100000
  fd.category = cat_food
end

fd2 = FoodDrink.find_or_create_by!(name: "Coffee") do |fd|
  fd.price = 30000
  fd.category = cat_drink
end

fd3 = FoodDrink.find_or_create_by!(name: "Burger") do |fd|
  fd.price = 80000
  fd.category = cat_food
end

fd4 = FoodDrink.find_or_create_by!(name: "Tea") do |fd|
  fd.price = 20000
  fd.category = cat_drink
end

# ----------------------------
# Orders
# ----------------------------
order1 = Order.find_or_create_by!(user: user, status: "Đang chờ", total_price: fd1.price + fd2.price)
order2 = Order.find_or_create_by!(user: user, status: "Hoàn thành", total_price: fd3.price + fd4.price)

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

puts "✅ Seed completed: Users, Categories, FoodDrinks, Orders, OrderItems"
