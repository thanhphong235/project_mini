# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  layout "admin" # layout riêng cho admin panel

  private

  def require_admin!
    redirect_to root_path, alert: "Bạn không có quyền truy cập" unless current_user&.admin?
  end
end
