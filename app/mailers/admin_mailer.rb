# app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer
  default from: ENV["ADMIN_EMAIL"]

  # params[:order] sẽ chứa đơn hàng
  def new_order
    @order = params[:order]

    mail(
      to: ENV["ADMIN_EMAIL"],
      subject: "Có đơn hàng mới từ #{@order.user.email}"
    )
  end
end
