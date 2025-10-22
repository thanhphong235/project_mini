class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :food_drink

  validates :score, presence: true, inclusion: { in: 1..5 }
  validates :comment, length: { maximum: 255 }
end
