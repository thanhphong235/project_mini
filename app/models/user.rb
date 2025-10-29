class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 facebook twitter]

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

  # ----------------------------
  # OAuth login / signup
  # ----------------------------
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize

    user.email = auth.info.email.presence || "#{auth.uid}@#{auth.provider}.com"
    user.name  = auth.info.name.presence || auth.info.nickname.presence || "User #{auth.uid}"
    user.password ||= Devise.friendly_token[0, 20]

    # Nếu email trùng ADMIN_EMAIL thì gán role admin
    admin_email = ENV['ADMIN_EMAIL']
    user.role = "admin" if user.email == admin_email

    # Mặc định user bình thường
    user.role ||= "user"

    user.save ? user : nil
  end

  private

  def set_default_role
    self.role ||= "user"
  end
end
