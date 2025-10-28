class SystemNotifier
  # Gửi email + chatwork khi có order mới
  def self.notify_order(order)
    # 1. Gửi email cho admin
    OrderMailer.new_order(order).deliver_later

    # 2. Gửi message Chatwork
    ChatworkService.send(order)
  end

  # Tạo thống kê cuối tháng
  def self.send_monthly_statistics
    start_date = Date.today.beginning_of_month
    end_date = Date.today.end_of_month

    orders = Order.where(ordered_at: start_date..end_date)
    total_orders = orders.count
    total_revenue = orders.sum(:total_price)

    top_products = orders.joins(:order_items)
                         .group("products.name")
                         .sum("order_items.quantity")
                         .sort_by { |_k, v| -v }
                         .first(10)
                         .to_h

    stats = { total_orders: total_orders, total_revenue: total_revenue, top_products: top_products }

    Admin.pluck(:email).each do |email|
      AdminMailer.monthly_statistics(email, stats).deliver_now
    end
  end
end
