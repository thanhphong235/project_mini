# db/seeds.rb
# frozen_string_literal: true

puts "🚀 Seed database bắt đầu..."

begin
  # ----------------------------
  # Admin test
  # ----------------------------
  if ActiveRecord::Base.connection.data_source_exists?('users')
    admin_email = "admin_test@example.com"
    admin_password = "123456"

    admin_test = User.find_or_initialize_by(email: admin_email)
    if admin_test.new_record?
      admin_test.name = "Admin Test"
      admin_test.role = "admin"
      admin_test.password = admin_password
      admin_test.password_confirmation = admin_password
      admin_test.confirmed_at = Time.current if admin_test.respond_to?(:confirmed_at)
      admin_test.save!
      puts "✅ Admin test mới tạo thành công!"
    else
      puts "⚠️ Admin test đã tồn tại, không thay đổi password"
    end
  else
    puts "⚠️ Table users chưa tồn tại, bỏ qua seed admin."
  end

  # ----------------------------
  # Categories
  # ----------------------------
  if ActiveRecord::Base.connection.data_source_exists?('categories')
    cat_food  = Category.find_or_create_by!(name: "Food")
    cat_drink = Category.find_or_create_by!(name: "Drink")
    puts "✅ Seed categories hoàn tất!"
  else
    puts "⚠️ Table categories chưa tồn tại, bỏ qua seed categories."
  end

  # ----------------------------
  # Món ăn & đồ uống
  # ----------------------------
  if ActiveRecord::Base.connection.data_source_exists?('food_drinks')
    default_foods_drinks = [
      { name: "Pizza",  price: 100_000, category: cat_food,  stock: 10 },
      { name: "Burger", price: 80_000,  category: cat_food,  stock: 15 },
      { name: "Coffee", price: 30_000,  category: cat_drink, stock: 20 },
      { name: "Tea",    price: 20_000,  category: cat_drink, stock: 25 }
    ]

    extra_foods_drinks = [
      { name: "Sushi",  price: 120_000, category: cat_food,  stock: 12 },
      { name: "Pasta",  price: 90_000,  category: cat_food,  stock: 10 },
      { name: "Salad",  price: 70_000,  category: cat_food,  stock: 15 },
      { name: "Steak",  price: 200_000, category: cat_food,  stock: 8 },
      { name: "French Fries", price: 40_000, category: cat_food,  stock: 20 },
      { name: "Sandwich",     price: 60_000, category: cat_food,  stock: 12 },
      { name: "Latte",  price: 35_000,  category: cat_drink, stock: 15 },
      { name: "Smoothie", price: 40_000, category: cat_drink, stock: 10 },
      { name: "Cappuccino", price: 38_000, category: cat_drink, stock: 12 },
      { name: "Hot Chocolate", price: 45_000, category: cat_drink, stock: 10 },
      { name: "Orange Juice",  price: 25_000, category: cat_drink, stock: 20 },
      { name: "Milkshake",     price: 50_000, category: cat_drink, stock: 8 }
    ]

    all_foods_drinks = default_foods_drinks + extra_foods_drinks

    all_foods_drinks.each do |fd_data|
      fd = FoodDrink.find_or_initialize_by(name: fd_data[:name])
      fd.update!(
        price: fd_data[:price],
        category: fd_data[:category],
        stock: fd_data[:stock],
        description: "Món #{fd_data[:name]} – hương vị hấp dẫn, phù hợp mọi khẩu vị."
      )
    end

    puts "✅ Seed món ăn & đồ uống hoàn tất!"
  else
    puts "⚠️ Table food_drinks chưa tồn tại, bỏ qua seed món ăn/đồ uống."
  end

  # ----------------------------
  # Users & Orders & OrderItems
  # ----------------------------
  if ActiveRecord::Base.connection.data_source_exists?('orders') &&
     ActiveRecord::Base.connection.data_source_exists?('order_items') &&
     ActiveRecord::Base.connection.data_source_exists?('users')

    users = User.where.not(role: "admin").to_a
    users << User.create!(
      name: "User Test",
      email: "user_test@example.com",
      password: "123456",
      password_confirmation: "123456",
      role: "user",
      confirmed_at: Time.current
    ) unless users.any?

    food_drinks = FoodDrink.all.to_a

    # Tạo 10 đơn hàng ngẫu nhiên (chỉ pending và completed)
    10.times do
      user = users.sample
      order = Order.create!(
        user: user,
        status: %i[pending completed].sample
      )

      selected_items = food_drinks.sample(rand(2..5))
      total_price = 0

      selected_items.each do |fd|
        quantity = rand(1..3)
        total_price += fd.price * quantity

        OrderItem.create!(
          order: order,
          food_drink: fd,
          quantity: quantity,
          price: fd.price
        )
      end

      order.update!(total_price: total_price)
    end

    puts "✅ Seed 10 đơn hàng ngẫu nhiên hoàn tất!"
  else
    puts "⚠️ Table orders hoặc order_items chưa tồn tại, bỏ qua seed orders."
  end

  # ----------------------------
  # Ratings
  # ----------------------------
  if ActiveRecord::Base.connection.data_source_exists?('ratings')
    ratings_data = [
      { food_name: "Pizza",   user: users.first, score: 5, comment: "Pizza ngon tuyệt vời!" },
      { food_name: "Pizza",   user: admin_test,   score: 4, comment: "Pizza ổn, có thể thêm phô mai." },
      { food_name: "Coffee",  user: users.first, score: 4, comment: "Cà phê thơm, ngon." },
      { food_name: "Coffee",  user: admin_test,   score: 3, comment: "Cà phê hơi đắng." },
      { food_name: "Burger",  user: users.first, score: 5, comment: "Burger mềm, thịt ngon." },
      { food_name: "Burger",  user: admin_test,   score: 4, comment: "Burger ngon, hơi ít sốt." },
      { food_name: "Tea",     user: users.first, score: 3, comment: "Trà bình thường." },
      { food_name: "Tea",     user: admin_test,   score: 4, comment: "Trà ngon, vị thanh nhẹ." },
      { food_name: "Sushi",   user: users.first, score: 5, comment: "Sushi tươi ngon, ăn là mê!" },
      { food_name: "Sushi",   user: admin_test,   score: 4, comment: "Sushi ổn, trang trí đẹp." },
      { food_name: "Latte",   user: users.first, score: 4, comment: "Latte thơm, uống rất thích." },
      { food_name: "Latte",   user: admin_test,   score: 3, comment: "Latte ngon nhưng hơi ngọt." }
    ]

    ratings_data.each do |data|
      fd = FoodDrink.find_by(name: data[:food_name])
      next unless fd

      r = Rating.find_or_initialize_by(food_drink: fd, user: data[:user])
      r.update!(score: data[:score], comment: data[:comment])
    end

    puts "✅ Seed ratings hoàn tất!"
  else
    puts "⚠️ Table ratings chưa tồn tại, bỏ qua seed ratings."
  end

  # ----------------------------
  # Doanh thu theo tháng (Revenue)
  # ----------------------------
  if ActiveRecord::Base.connection.data_source_exists?('orders')
    6.times do |i|
      month = i + 1
      year = Time.current.year
      start_of_month = Time.new(year, month, 1)
      end_of_month   = start_of_month.end_of_month

      rand(3..6).times do
        user = users.sample
        order = Order.create!(
          user: user,
          status: %i[pending completed].sample,
          created_at: rand(start_of_month..end_of_month)
        )

        selected_items = food_drinks.sample(rand(2..4))
        total_price = 0

        selected_items.each do |fd|
          quantity = rand(1..3)
          total_price += fd.price * quantity

          OrderItem.create!(
            order: order,
            food_drink: fd,
            quantity: quantity,
            price: fd.price
          )
        end

        order.update!(total_price: total_price)
      end
    end

    revenue_by_month = Order.completed
                            .group_by { |o| o.created_at.strftime("%Y-%m") }
                            .transform_values { |orders| orders.sum(&:total_price) }

    puts "📊 Doanh thu theo tháng (completed orders):"
    revenue_by_month.each do |month, revenue|
      puts "   #{month}: #{revenue} VND"
    end

    puts "✅ Seed doanh thu theo tháng hoàn tất!"
  end

  # ----------------------------
  # Kết thúc
  # ----------------------------
  puts "--------------------------------------------"
  puts "👨‍💻 Admin test account:"
  puts "   Email: #{admin_email}"
  puts "   Password: #{admin_password}"
  puts "--------------------------------------------"
  puts "✅ Seed database hoàn tất!"
rescue => e
  puts "❌ Seed thất bại: #{e.message}"
end
