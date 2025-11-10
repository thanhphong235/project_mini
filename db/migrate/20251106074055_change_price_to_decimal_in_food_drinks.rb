class ChangePriceToDecimalInFoodDrinks < ActiveRecord::Migration[7.1]
  def change
  change_column :food_drinks, :price, :decimal, precision: 10, scale: 2, using: 'price::numeric'
end

end
