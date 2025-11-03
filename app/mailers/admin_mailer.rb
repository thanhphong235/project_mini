class AdminMailer < ApplicationMailer
  default from: ENV.fetch("ADMIN_EMAIL", "no-reply@example.com")

  def monthly_order_summary(orders, month, year)
    @orders = orders
    @month = month
    @year = year

    mail(
      to: ENV.fetch("ADMIN_EMAIL", "admin@example.com"),
      subject: "📊 Thống kê đơn hàng tháng #{@month}/#{@year}"
    )
  end
end
