class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
  end

  private

  def require_admin
    unless current_user.role == "admin"
      redirect_to root_path, alert: "Bạn không có quyền truy cập trang này!"
    end
  end
end
