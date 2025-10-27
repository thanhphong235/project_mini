# app/models/user.rb
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 facebook twitter]

  # Constants
  ROLES = %w[user admin].freeze

  # Associations
  has_many :cart_items
  has_many :food_drinks, through: :cart_items
  has_many :orders, dependent: :destroy
  has_many :suggestions, dependent: :destroy
  has_many :ratings, dependent: :destroy


  # Callbacks
  before_create :set_default_role

  # Role helpers
  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end

  # Class method: tạo hoặc tìm user từ dữ liệu OAuth
def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
    # Nếu không có email (Facebook có thể ẩn email), tạo email tạm
    user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
    user.name  = auth.info.name || auth.info.nickname || "User #{auth.uid}"
    user.password ||= Devise.friendly_token[0, 20]
    user.role ||= "user"
    user.save if user.changed?
  end
end

  private

  # Set role mặc định là "user"
  def set_default_role
    self.role ||= "user"
  end
end
