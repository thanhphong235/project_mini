class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2 twitter]

  before_create :set_default_role

  ROLES = %w[user admin]

  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end

  has_many :cart_items
  has_many :food_drinks, through: :cart_items
  has_many :orders, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name  = auth.info.name || auth.info.nickname
      user.password = Devise.friendly_token[0, 20]
      user.role = "user"
    end
  end

  private

  def set_default_role
    self.role ||= "user"
  end
end
