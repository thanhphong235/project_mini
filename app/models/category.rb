class Category < ApplicationRecord
  has_many :food_drinks, dependent: :destroy
end
