module Admin
  class UsersController < ApplicationController
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
      format.turbo_stream { flash[:alert] = "Không thể xóa admin." }
    end
    return
  end

  @user.destroy

  respond_to do |format|
    format.html { redirect_to admin_users_path, notice: "Người dùng đã bị xóa." }
    format.turbo_stream { flash[:notice] = "Người dùng đã bị xóa." }
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
