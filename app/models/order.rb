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

  # Callback trả lại sản phẩm về kho khi hủy đơn
  after_update :handle_cancelled_order, if: :saved_change_to_status?

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

  private

  def handle_cancelled_order
    return unless cancelled?

    # Trả lại số lượng các món về kho
    order_items.each do |item|
      food = item.food_drink
      next unless food.respond_to?(:stock) # Nếu food có trường stock
      food.increment!(:stock, item.quantity)
    end
  end
end
