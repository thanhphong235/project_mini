class FoodDrink < ApplicationRecord
  belongs_to :category       # <-- thay thế category string bằng liên kết tới Category
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: true
  validates :category_id, presence: true    # bắt buộc chọn Category

  has_many :ratings
  has_many :cart_items
  has_many :order_items
  has_many :orders, through: :order_items

end
