class AddCategoryToFoodDrinks < ActiveRecord::Migration[7.1]
  def change
    add_reference :food_drinks, :category, null: false,ign_key: true
  end
end
