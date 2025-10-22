class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum status: {
    pending: 0,       # Đang chờ xử lý
    confirmed: 1,     # Đã xác nhận
    delivering: 2,    # Đang giao
    completed: 3,     # Hoàn tất
    cancelled: 4      # Đã hủy
  }

  def self.status_human_for(key)
    {
      "pending" => "Đang chờ xử lý",
      "confirmed" => "Đã xác nhận",
      "delivering" => "Đang giao",
      "completed" => "Hoàn tất",
      "cancelled" => "Đã hủy"
    }[key]
  end

  def status_human
    self.class.status_human_for(status)
  end
end
