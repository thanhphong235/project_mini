class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :food_drink

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
