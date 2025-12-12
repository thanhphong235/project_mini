class Admin::OrdersController < Admin::BaseController
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
    notice = if @order.cancelled?
      "Đơn hàng đã hủy. Các món ăn đã trả về kho."
    else
      "Cập nhật trạng thái đơn hàng thành công."
    end

    respond_to do |format|
      format.html { redirect_to admin_order_path(@order), notice: notice }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.prepend(
            "flash_messages",
            partial: "shared/flash",
            locals: { notice: notice }
          ),
          turbo_stream.replace(
            "order_status_#{@order.id}",
            partial: "admin/orders/status_badge",
            locals: { order: @order }
          ),
          turbo_stream.replace(
            "order_delete_button_#{@order.id}",
            partial: "admin/orders/delete_button",
            locals: { order: @order }  # partial sẽ disable nếu order.cancelled?
          )
        ]
      end
    end
  else
    alert = "Không thể cập nhật đơn hàng."
    respond_to do |format|
      format.html { redirect_to admin_order_path(@order), alert: alert }
      format.turbo_stream do
        render turbo_stream: turbo_stream.prepend(
          "flash_messages",
          partial: "shared/flash",
          locals: { alert: alert }
        )
      end
    end
  end
end

def destroy
  if @order.status != "pending"
    alert = "Đơn hàng đã xử lý, không thể xóa."
    respond_to do |format|
      format.html { redirect_to admin_orders_path, alert: alert }
      format.turbo_stream do
        render turbo_stream: turbo_stream.prepend(
          "flash_messages",
          partial: "shared/flash",
          locals: { alert: alert }
        )
      end
    end
    return
  end

  @order.destroy
  notice = "Đã xóa đơn hàng thành công."

  respond_to do |format|
    format.html { redirect_to admin_orders_path, notice: notice }
    format.turbo_stream do
      render turbo_stream: [
        turbo_stream.remove("order_#{@order.id}"),
        turbo_stream.prepend(
          "flash_messages",
          partial: "shared/flash",
          locals: { notice: notice }
        )
      ]
    end
  end
end


  # ======================
  # THỐNG KÊ ĐƠN HÀNG THEO THÁNG/NĂM
  # ======================
  def statistics
    @month = (params[:month] || Time.current.month).to_i
    @year  = (params[:year] || Time.current.year).to_i

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
