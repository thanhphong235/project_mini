# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Cho phép thêm trường name khi đăng ký & cập nhật
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # Sau khi đăng nhập, redirect theo loại user
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path   # Admin → vào trang admin
    else
      food_drinks_path       # User → vào trang food & drinks
    end
  end

  # Sau khi đăng xuất, quay về trang chủ
  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
end
