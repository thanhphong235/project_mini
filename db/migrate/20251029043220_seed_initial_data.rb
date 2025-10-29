class SeedInitialData < ActiveRecord::Migration[7.1]
  def up
    # ----------------------------
    # Users
    # ----------------------------
    admin = User.find_or_initialize_by(email: "admin@example.com")
    admin.update!(
      name: "Admin User",
      password: "123456",
      role: "admin"
    )

    user = User.find_or_initialize_by(email: "user@example.com")
    user.update!(
      name: "Test User",
      password: "123456",
      role: "user"
    )

    # ----------------------------
    # Categories
    # ----------------------------
    cat_food = Category.find_or_create_by!(name: "Food")
    cat_drink = Category.find_or_create_by!(name: "Drink")

    # ----------------------------
    # Food & Drinks
    # ----------------------------
    foods_drinks_seed = [
      { name: "Pizza", price: 100_000, category: cat_food, stock: 10 },
      { name: "Burger", price: 80_000, category: cat_food, stock: 15 },
      { name: "Coffee", price: 30_000, category: cat_drink, stock: 20 },
      { name: "Tea", price: 20_000, category: cat_drink, stock: 25 }
    ]

    foods_drinks_seed.each do |fd_data|
      fd = FoodDrink.find_or_initialize_by(name: fd_data[:name])
      fd.update!(
        price: fd_data[:price],
        category: fd_data[:category],
        stock: fd_data[:stock]
      )
    end

    # Lấy lại các món vừa tạo hoặc tồn tại
    fd1 = FoodDrink.find_by(name: "Pizza")
    fd2 = FoodDrink.find_by(name: "Coffee")
    fd3 = FoodDrink.find_by(name: "Burger")
    fd4 = FoodDrink.find_by(name: "Tea")

    # ----------------------------
    # Orders
    # ----------------------------
    order1 = Order.find_or_initialize_by(user: user, status: :pending, total_price: fd1.price + fd2.price)
    order1.save! unless order1.persisted?

    order2 = Order.find_or_initialize_by(user: user, status: :completed, total_price: fd3.price + fd4.price)
    order2.save! unless order2.persisted?

    # ----------------------------
    # Order Items
    # ----------------------------
    [
      { order: order1, food_drink: fd1, quantity: 1 },
      { order: order1, food_drink: fd2, quantity: 1 },
      { order: order2, food_drink: fd3, quantity: 1 },
      { order: order2, food_drink: fd4, quantity: 1 }
    ].each do |oi_data|
      oi = OrderItem.find_or_initialize_by(order: oi_data[:order], food_drink: oi_data[:food_drink])
      oi.update!(
        quantity: oi_data[:quantity],
        price: oi_data[:food_drink].price
      )
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
      r = Rating.find_or_initialize_by(food_drink: data[:food_drink], user: data[:user])
      r.update!(
        score: data[:score],
        comment: data[:comment]
      )
    end

    puts "✅ Seed completed: Users, Categories, FoodDrinks, Orders, OrderItems, Ratings"
  end

  def down
    Rating.delete_all
    OrderItem.delete_all
    Order.delete_all
    FoodDrink.delete_all
    Category.delete_all
    User.where(email: ["admin@example.com", "user@example.com"]).delete_all
  end
end
