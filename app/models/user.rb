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

  # Validations
  validates :role, inclusion: { in: ROLES }

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
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.email = auth.info.email.presence || "#{auth.uid}@#{auth.provider}.com"
    user.name  = auth.info.name.presence || auth.info.nickname.presence || "User #{auth.uid}"
    user.password ||= Devise.friendly_token[0, 20]
    user.role ||= "user"

    # Lưu user nếu có thay đổi, return nil nếu save thất bại
    user.save ? user : nil
  end

  private

  # Set role mặc định là "user"
  def set_default_role
    self.role ||= "user"
  end
end
