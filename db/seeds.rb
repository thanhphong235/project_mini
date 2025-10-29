puts "⚡ Seeding Categories & FoodDrinks..."

# ----------------------------
# Categories
# ----------------------------
cat_food = Category.find_or_create_by!(name: "Food")
cat_drink = Category.find_or_create_by!(name: "Drink")

puts "✅ Categories seeded: #{[cat_food.name, cat_drink.name].join(', ')}"

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
  fd = FoodDrink.find_or_create_by!(name: fd_data[:name]) do |f|
    f.price = fd_data[:price]
    f.category = fd_data[:category]
    f.stock = fd_data[:stock]
  end
end

puts "✅ Food & Drinks seeded: #{FoodDrink.pluck(:name).join(', ')}"

puts "⚡ Production seed completed!"
