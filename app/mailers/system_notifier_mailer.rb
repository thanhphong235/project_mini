class SystemNotifierMailer < ApplicationMailer
  default from: ENV['GMAIL_USERNAME']

  # Gửi thông báo khi đơn hàng được tạo
  def order_created(order)
    @order = order

    mail(
      to: @order.user.email,
      subject: "Đơn hàng ##{@order.id} của bạn đã được tạo"
    ) do |format|
      format.html { render "order_created" }  # email HTML
      format.text { render plain: "Đơn hàng ##{@order.id} của bạn đã được tạo.\nTổng giá: #{@order.total_price} VND" }  # email text
    end
  end
end
