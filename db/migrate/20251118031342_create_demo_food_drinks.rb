class CreateDemoFoodDrinks < ActiveRecord::Migration[7.0]
  def up
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
      FoodDrink.find_or_create_by!(name: fd_data[:name]) do |fd|
        fd.price = fd_data[:price]
        fd.stock = fd_data[:stock]
        fd.category = fd_data[:category]
        fd.description = "Món #{fd_data[:name]} – hương vị hấp dẫn, phù hợp mọi khẩu vị."
      end
    end

    # ----------------------------
    # 20 món demo
    # ----------------------------
    extra_items = [
      "Phở bò", "Bún chả", "Bún bò Huế", "Cơm tấm", "Bánh mì",
      "Cháo gà", "Bánh cuốn", "Mì Quảng", "Bánh xèo", "Hủ tiếu",
      "Sinh tố xoài", "Trà đào", "Trà sữa trân châu", "Nước cam",
      "Soda chanh", "Cà phê đen", "Capuchino", "Latte đá",
      "Pizza hải sản", "Hamburger gà"
    ]

    extra_items.each do |name|
      category = if name.include?("Trà") || name.include?("Cà") || name.include?("Nước") || name.include?("Sinh tố") || name.include?("Soda")
                   cat_drink
                 else
                   cat_food
                 end

      FoodDrink.find_or_create_by!(name: name) do |fd|
        fd.price = rand(20_000..120_000)
        fd.stock = rand(10..50)
        fd.category = category
        fd.description = "Món #{name} được chế biến theo công thức đặc biệt."
      end
    end

    # ----------------------------
    # Ratings cho 4 món mặc định
    # ----------------------------
    # Cần có ít nhất 1 user & 1 admin
    admin = User.find_by(role: "admin")
    user  = User.where.not(id: admin&.id).first

    if admin && user
      ratings_data = [
        { food_drink_name: "Pizza",  user: user,  score: 1, comment: "Pizza ngon tuyệt vời!" },
        { food_drink_name: "Pizza",  user: admin, score: 4, comment: "Pizza ổn, có thể thêm phô mai." },
        { food_drink_name: "Coffee", user: user,  score: 4, comment: "Cà phê thơm, ngon." },
        { food_drink_name: "Coffee", user: admin, score: 3, comment: "Cà phê hơi đắng." },
        { food_drink_name: "Burger", user: user,  score: 5, comment: "Burger mềm, thịt ngon." },
        { food_drink_name: "Burger", user: admin, score: 4, comment: "Burger ngon, hơi ít sốt." },
        { food_drink_name: "Tea",    user: user,  score: 3, comment: "Trà bình thường." },
        { food_drink_name: "Tea",    user: admin, score: 4, comment: "Trà ngon, vị thanh nhẹ." }
      ]

      ratings_data.each do |data|
        fd = FoodDrink.find_by(name: data[:food_drink_name])
        next unless fd

        Rating.find_or_create_by!(food_drink: fd, user: data[:user]) do |r|
          r.score = data[:score]
          r.comment = data[:comment]
        end
      end
    end
  end

  def down
    # Xóa 20 món demo
    extra_items = [
      "Phở bò", "Bún chả", "Bún bò Huế", "Cơm tấm", "Bánh mì",
      "Cháo gà", "Bánh cuốn", "Mì Quảng", "Bánh xèo", "Hủ tiếu",
      "Sinh tố xoài", "Trà đào", "Trà sữa trân châu", "Nước cam",
      "Soda chanh", "Cà phê đen", "Capuchino", "Latte đá",
      "Pizza hải sản", "Hamburger gà"
    ]
    FoodDrink.where(name: extra_items).delete_all

    # Xóa 4 món mặc định
    ["Pizza", "Burger", "Coffee", "Tea"].each do |name|
      FoodDrink.find_by(name: name)&.destroy
    end
  end
end
