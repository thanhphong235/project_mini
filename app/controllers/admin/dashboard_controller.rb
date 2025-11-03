class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
  end

  # =========================
  # 📊 Thống kê đơn hàng
  # =========================
  def order_statistics
    # Lấy tháng và năm từ params hoặc dùng mặc định là tháng hiện tại
    @month = (params[:month] || Date.current.month).to_i
    @year = (params[:year] || Date.current.year).to_i

    # Tạo khoảng thời gian từ đầu tháng đến cuối tháng được chọn
    start_date = Date.new(@year, @month, 1).beginning_of_day
    end_date = start_date.end_of_month.end_of_day

    # Lọc đơn hàng theo khoảng thời gian
    @orders = Order.includes(:user).where(created_at: start_date..end_date).order(created_at: :desc)

    # Tính thống kê
    @total_orders = @orders.count
    @total_revenue = @orders.sum(:total_price)
  end

  # =========================
  # 📧 Gửi thống kê qua email
  # =========================
  def send_statistics
    @month = (params[:month] || Date.current.month).to_i
    @year = (params[:year] || Date.current.year).to_i

    start_date = Date.new(@year, @month, 1).beginning_of_day
    end_date = start_date.end_of_month.end_of_day

    orders = Order.where(created_at: start_date..end_date)
    total_orders = orders.count
    total_revenue = orders.sum(:total_price)

    # Gửi mail cho admin hiện tại
    AdminMailer.monthly_statistics(current_user, @month, @year, total_orders, total_revenue).deliver_later

    redirect_to admin_order_statistics_path(month: @month, year: @year),
                notice: "📧 Báo cáo thống kê tháng #{@month}/#{@year} đã được gửi qua email!"
  end

  def send_monthly_report
    @month = params[:month].to_i
    @year = params[:year].to_i

    start_date = Date.new(@year, @month, 1).beginning_of_day
    end_date = start_date.end_of_month.end_of_day

    @orders = Order.includes(:user).where(created_at: start_date..end_date)

    if @orders.any?
      AdminMailer.monthly_order_summary(@orders, @month, @year).deliver_now
      flash[:notice] = "✅ Báo cáo thống kê tháng #{@month}/#{@year} đã được gửi qua email admin."
    else
      flash[:alert] = "⚠️ Không có đơn hàng nào trong tháng #{@month}/#{@year}."
    end

    redirect_to admin_order_statistics_path(month: @month, year: @year)
  end



  private

  def require_admin
    unless current_user.admin? || current_user.role == "admin"
      redirect_to root_path, alert: "🚫 Bạn không có quyền truy cập trang này!"
    end
  end
end
