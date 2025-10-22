# app/controllers/admin/orders_controller.rb
class Admin::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]

  # GET /admin/orders
  def index
    @orders = Order.includes(:user).order(created_at: :desc)
  end

  # GET /admin/orders/:id
  def show
  end

  # DELETE /admin/orders/:id
  def destroy
    @order.destroy
    redirect_to admin_orders_path, notice: "Đơn hàng đã được xóa thành công."
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
