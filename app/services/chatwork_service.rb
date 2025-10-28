require 'httparty'

class ChatworkService
  CHATWORK_API_TOKEN = ENV["CHATWORK_API_TOKEN"]
  CHATWORK_ROOM_ID   = ENV["CHATWORK_ROOM_ID"]

  def self.send_message(order)
    details = order.order_items.map { |i| "- #{i.food_drink.name} x #{i.quantity}" }.join("\n")
    message = "[info][title]Đơn hàng mới ##{order.id}[/title]" \
              "Người đặt: #{order.user.name || order.user.email}\n" \
              "Tổng giá: #{order.total_price}\n" \
              "Chi tiết:\n#{details}[/info]"

    response = HTTParty.post(
      "https://api.chatwork.com/v2/rooms/#{CHATWORK_ROOM_ID}/messages",
      headers: { "X-ChatWorkToken" => CHATWORK_API_TOKEN },
      body: { body: message }
    )

    unless response.success?
      Rails.logger.error("Chatwork API Error: #{response.body}")
      raise "Chatwork API Error: #{response.body}"
    end
  end
end
