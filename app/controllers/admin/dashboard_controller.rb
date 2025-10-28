class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
  end

  # Thêm action thống kê
  def order_statistics
    # Lấy tất cả đơn hàng từ đầu tháng đến hôm nay
    start_of_month = Time.current.beginning_of_month
    end_of_day = Time.current.end_of_day
    @orders = Order.where(created_at: start_of_month..end_of_day)

    # Tổng số đơn hàng
    @total_orders = @orders.count
    # Tổng doanh thu
    @total_revenue = @orders.sum(:total_price)
  end

  private

  def require_admin
    unless current_user.role == "admin"
      redirect_to root_path, alert: "Bạn không có quyền truy cập trang này!"
    end
  end
end
