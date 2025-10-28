class SystemNotifierJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 1

  def perform(order_id)
    order = Order.find(order_id)

    # 1️⃣ Gửi email
    begin
      OrderMailer.new_order(order).deliver_later
    rescue => e
      Rails.logger.error("Failed to send order email: #{e.message}")
    end

    # 2️⃣ Gửi Chatwork message
    begin
      ChatworkService.send_message(order)
    rescue => e
      Rails.logger.error("Failed to send Chatwork message: #{e.message}")
    end
  end
end
