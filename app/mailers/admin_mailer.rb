class AdminMailer < ApplicationMailer
  default from: ENV.fetch("ADMIN_EMAIL")

  # Mail gửi thống kê hàng tháng
  def monthly_order_summary(orders, month, year)
    @orders = orders
    @month = month
    @year = year

    mail(
      to: ENV.fetch("ADMIN_EMAIL"),
      subject: "📊 Thống kê đơn hàng tháng #{@month}/#{@year}"
    )
  end

  # Mail gửi khi có đơn hàng mới
  def new_order
    @order = params[:order]
    @user = @order.user

    mail(
      to: ENV.fetch("ADMIN_EMAIL"), # mail admin
      subject: "🛒 Đơn hàng mới ##{@order.id} từ #{@user.name}"
    )
  end
end
