class FoodDrink < ApplicationRecord
   has_one_attached :image

  validates :name, :category, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
