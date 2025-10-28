class OrderMailer < ApplicationMailer
  default from: ENV['GMAIL_USERNAME'] # email gửi đi

  def new_order(order)
    @order = order
    @user = @order.user
    mail(to: @user.email, subject: "Đơn hàng ##{@order.id} của bạn đã được tạo")
  end
end
