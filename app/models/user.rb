class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[user admin]

  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end

  before_create :set_default_role

  private

  def set_default_role
    self.role ||= "user"
  end
end
