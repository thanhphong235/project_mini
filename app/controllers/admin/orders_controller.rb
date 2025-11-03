class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_order, only: [:show, :update, :destroy]

  # ======================
  # QUẢN LÝ ĐƠN HÀNG
  # ======================

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

  # ======================
  # THỐNG KÊ ĐƠN HÀNG THEO THÁNG/NĂM
  # ======================
  def statistics
    @month = (params[:month] || Time.current.month).to_i
    @year  = (params[:year] || Time.current.year).to_i

    # Lọc đơn hàng theo tháng và năm
    if ActiveRecord::Base.connection.adapter_name.downcase.include?("mysql")
      @orders = Order.where("MONTH(created_at) = ? AND YEAR(created_at) = ?", @month, @year)
    else
      @orders = Order.where("EXTRACT(MONTH FROM created_at) = ? AND EXTRACT(YEAR FROM created_at) = ?", @month, @year)
    end

    @total_orders  = @orders.count
    @total_revenue = @orders.sum(:total_price)
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
