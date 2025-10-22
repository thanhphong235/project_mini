class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def update
    if @order.update(order_params)
      redirect_to admin_orders_path, notice: "Cập nhật trạng thái đơn hàng thành công."
    else
      redirect_to admin_orders_path, alert: "Không thể cập nhật đơn hàng."
    end
  end

  def destroy
    @order.destroy
    redirect_to admin_orders_path, notice: "Đã xóa đơn hàng thành công."
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: "Bạn không có quyền truy cập." unless current_user.admin?
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
