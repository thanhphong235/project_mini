class AddStockToFoodDrinks < ActiveRecord::Migration[7.0]
  def change
    add_column :food_drinks, :stock, :integer, default: 0, null: false
  end
end
