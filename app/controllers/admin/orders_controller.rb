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
  if @order.status != "pending"
    respond_to do |format|
      format.html { redirect_to admin_orders_path, alert: "Đơn hàng đã xử lý, không thể xóa." }

      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "flash_messages",
          partial: "shared/flash_messages",
          locals: { notice: nil, alert: " không thể xóa." }
        )
      end
    end
    return
  end

  # Xóa nếu pending
  @order.destroy

  respond_to do |format|
    format.html { redirect_to admin_orders_path, notice: "Đã xóa đơn hàng thành công." }
    format.turbo_stream
  end
end




  # ======================
  # THỐNG KÊ ĐƠN HÀNG THEO THÁNG/NĂM
  # ======================
def order_statistics
  @month = params[:month]&.to_i || Time.current.month
  @year  = params[:year]&.to_i  || Time.current.year

  # Lấy tất cả đơn theo tháng/năm, preload user
  @orders = Order.includes(:user)
                 .where("extract(month from created_at) = ? AND extract(year from created_at) = ?", @month, @year)
                 .order(created_at: :desc)

  # Tổng số đơn
  @total_orders = @orders.size

  # Tổng doanh thu: chỉ tính đơn completed
  @total_revenue = @orders.select { |o| o.completed? }.sum(&:total_price)
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
