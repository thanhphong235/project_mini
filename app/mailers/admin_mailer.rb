# app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer
  default from: ENV["ADMIN_EMAIL"]

  # Mail thông báo đơn hàng mới
  def new_order
    @order = params[:order]

    mail(
      to: ENV["ADMIN_EMAIL"],
      subject: "Có đơn hàng mới từ #{@order.user.email}"
    )
  end

  # Mail thống kê đơn hàng hàng tháng
  def monthly_order_summary
    @orders = params[:orders]       # Danh sách đơn hàng
    @month = params[:month]         # Tháng
    @year = params[:year]           # Năm

    mail(
      to: ENV["ADMIN_EMAIL"],
      subject: "Thống kê đơn hàng #{@month}/#{@year}"
    )
  end
end
