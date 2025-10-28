class OrdersController < ApplicationController
  before_action :authenticate_user!

  # Hiển thị chi tiết một đơn hàng
  def show
    @order = current_user.orders.includes(order_items: :food_drink).find(params[:id])
  end

  # Hiển thị danh sách đơn hàng của user
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  # Tạo đơn hàng từ giỏ hàng
  def create
    cart_items = current_user.cart_items.includes(:food_drink)

    if cart_items.empty?
      redirect_to cart_path, alert: "Giỏ hàng trống, không thể đặt hàng."
      return
    end

    total_price = cart_items.sum { |item| item.food_drink.price * item.quantity }

    begin
      order = nil

      # Transaction chỉ để thao tác DB
      ActiveRecord::Base.transaction do
        order = current_user.orders.create!(total_price: total_price, status: "pending")

        cart_items.each do |item|
          order.order_items.create!(
            food_drink: item.food_drink,
            quantity: item.quantity,
            price: item.food_drink.price
          )
        end

        cart_items.destroy_all
      end

      # Gửi mail và job **sau khi transaction commit**
      OrderMailer.new_order(order).deliver_now

      SystemNotifierJob.perform_later(order.id)

      redirect_to order_path(order), notice: "Đặt hàng thành công!"
    rescue ActiveRecord::RecordInvalid => e
      redirect_to cart_path, alert: "Đặt hàng thất bại: #{e.record.errors.full_messages.join(', ')}"
    rescue => e
      redirect_to cart_path, alert: "Đặt hàng thất bại: #{e.message}"
    end
  end
end
