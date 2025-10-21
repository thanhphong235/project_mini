class CreateFoodDrinks < ActiveRecord::Migration[7.1]
  def change
    create_table :food_drinks do |t|
      t.string :name
      t.text :description
      t.string :category
      t.decimal :price

      t.timestamps
    end
  end
end
