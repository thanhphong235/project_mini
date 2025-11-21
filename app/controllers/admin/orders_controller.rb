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
  respond_to do |format|
    if @order.update(order_params)
      notice = "Cập nhật trạng thái đơn hàng thành công."

      format.html { redirect_to admin_order_path(@order), notice: notice }
      format.turbo_stream do
        render turbo_stream: [
          # Cập nhật flash
          turbo_stream.update(
            "flash_messages",
            "<div class='alert alert-success alert-dismissible fade show mt-2' role='alert'>
              #{notice}
              <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Đóng'></button>
            </div>".html_safe
          ),
          # Cập nhật status badge
          turbo_stream.replace(
            "order_status_#{@order.id}",
            partial: "admin/orders/status_badge",
            locals: { order: @order }
          )
        ]
      end
    else
      alert = "Không thể cập nhật đơn hàng."
      format.html { redirect_to admin_order_path(@order), alert: alert }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "flash_messages",
          "<div class='alert alert-danger alert-dismissible fade show mt-2' role='alert'>
            #{alert}
            <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Đóng'></button>
          </div>".html_safe
        )
      end
    end
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
