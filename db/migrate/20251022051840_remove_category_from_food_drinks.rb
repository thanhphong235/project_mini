class RemoveCategoryFromFoodDrinks < ActiveRecord::Migration[7.1]
  def change
    remove_column :food_drinks, :category, :string
  end
end
