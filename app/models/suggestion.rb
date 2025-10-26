class Suggestion < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  after_initialize :set_default_status

  private
  def set_default_status
    self.status ||= "pending"
  end
end
