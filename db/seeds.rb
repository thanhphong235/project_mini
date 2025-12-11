# db/seeds.rb
puts "🚀 Seed database bắt đầu..."

begin
  # ----------------------------
  # Admin test
  # ----------------------------
  admin_email = "admin_test@example.com"
  admin_password = "123456"

  admin_test = User.find_or_initialize_by(email: admin_email)
  if admin_test.new_record?
    admin_test.name = "Admin Test"
    admin_test.role = "admin"
    admin_test.password = admin_password
    admin_test.password_confirmation = admin_password
    admin_test.save!
    puts "✅ Admin test mới tạo thành công!"
  else
    puts "⚠️ Admin test đã tồn tại"
  end

  # ----------------------------
  # Categories
  # ----------------------------
  cat_food  = Category.find_or_create_by!(name: "Food")
  cat_drink = Category.find_or_create_by!(name: "Drink")

  # ----------------------------
  # Món ăn & đồ uống
  # ----------------------------
  foods_drinks_data = [
    { name: "Pizza",  price: 100_000, category: cat_food },
    { name: "Burger", price: 80_000,  category: cat_food },
    { name: "Coffee", price: 30_000,  category: cat_drink },
    { name: "Tea",    price: 20_000,  category: cat_drink },
    { name: "Sushi",  price: 120_000, category: cat_food },
    { name: "Latte",  price: 35_000,  category: cat_drink }
  ]

  foods_drinks_data.each do |fd|
    FoodDrink.find_or_create_by!(name: fd[:name]) do |f|
      f.price = fd[:price]
      f.category = fd[:category]
      f.stock = 10
      f.description = "Món #{fd[:name]} – hương vị hấp dẫn."
    end
  end

  # ----------------------------
  # User bình thường
  # ----------------------------
  user = User.where.not(id: admin_test.id).first
  unless user
    attrs = { name: "Normal User", email: "normal_user@example.com", password: "123456", password_confirmation: "123456", role: "user" }
    attrs[:confirmed_at] = Time.current if User.new.respond_to?(:confirmed_at=)
    user = User.create!(attrs)
  end

  # ----------------------------
  # Orders
  # ----------------------------
  pizza  = FoodDrink.find_by(name: "Pizza")
  coffee = FoodDrink.find_by(name: "Coffee")
  latte  = FoodDrink.find_by(name: "Latte")

  order = Order.find_or_create_by!(user: user, status: :completed) do |o|
    o.total_price = pizza.price + coffee.price + latte.price
  end

  [
    { food_drink: pizza,  quantity: 1 },
    { food_drink: coffee, quantity: 1 },
    { food_drink: latte,  quantity: 1 }
  ].each do |item|
    OrderItem.find_or_create_by!(order: order, food_drink: item[:food_drink]) do |oi|
      oi.quantity = item[:quantity]
      oi.price = item[:food_drink].price
    end
  end

  # ----------------------------
  # Ratings
  # ----------------------------
  [
    { food_drink: pizza, user: user, score: 5, comment: "Pizza ngon tuyệt vời!" },
    { food_drink: coffee, user: user, score: 4, comment: "Cà phê thơm, ngon." },
    { food_drink: latte, user: user, score: 4, comment: "Latte thơm, uống rất thích." }
  ].each do |r|
    next unless r[:food_drink]
    Rating.find_or_create_by!(food_drink: r[:food_drink], user: r[:user]) do |rate|
      rate.score = r[:score]
      rate.comment = r[:comment]
    end
  end

  puts "✅ Seed database hoàn tất!"
  puts "Admin test: #{admin_email} / #{admin_password}"

rescue => e
  puts "❌ Seed thất bại: #{e.message}"
end
