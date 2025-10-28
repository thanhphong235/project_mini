# app/mailers/order_mailer.rb
class OrderMailer < ApplicationMailer
  default from: ENV["ADMIN_EMAIL"]

  def new_order
    @order = params[:order]
    @user = @order.user

    mail(
      to: @user.email,
      subject: "Xác nhận đơn hàng của bạn ##{@order.id}"
    )
  end
end
