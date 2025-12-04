module Admin
  class UsersController < Admin::BaseController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_user, only: [:show, :destroy]

    def index
      @users = User.order(Arel.sql("CASE WHEN role = 'admin' THEN 0 ELSE 1 END, created_at DESC"))
    end

    def show
      # Hiển thị chi tiết user
    end

def destroy
  if @user.admin?
    respond_to do |format|
      format.html { redirect_to admin_users_path, alert: "Không thể xóa admin." }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "flash_messages",
          partial: "shared/flash_messages",
          locals: { notice: nil, alert: "Không thể xóa admin." }
        )
      end
    end
    return
  end

  @user.destroy

  respond_to do |format|
    format.html { redirect_to admin_users_path, notice: "Người dùng đã bị xóa." }
    format.turbo_stream do
      render turbo_stream: turbo_stream.remove(@user) +
                            turbo_stream.update(
                              "flash_messages",
                              partial: "shared/flash_messages",
                              locals: { notice: "Người dùng đã bị xóa.", alert: nil }
                            )
    end
  end
end





    private

    def set_user
      @user = User.find(params[:id])
    end

    def require_admin
      redirect_to root_path, alert: "Không có quyền truy cập!" unless current_user.admin?
    end
  end
end
