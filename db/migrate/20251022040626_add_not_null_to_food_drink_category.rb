class AddNotNullToFoodDrinkCategory < ActiveRecord::Migration[7.1]
  def change
    change_column_null :food_drinks, :category_id, false
  end
end
