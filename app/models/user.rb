class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[user admin]

  before_create :set_default_role

  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end

  private

  def set_default_role
    self.role ||= "user"
  end

  # Quan hệ với cart
  has_many :cart_items
  has_many :food_drinks, through: :cart_items
end
