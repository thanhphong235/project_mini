# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  # Trạng thái tiếng Việt
  def status_human
    case status
    when "pending" then "Đang chờ"
    when "completed" then "Hoàn thành"
    when "cancelled" then "Đã hủy"
    else status
    end
  end
end
