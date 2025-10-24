class FoodDrink < ApplicationRecord
  belongs_to :category
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: true
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category_id, presence: true

  has_many :ratings
  has_many :cart_items
  has_many :order_items
  has_many :orders, through: :order_items
end
