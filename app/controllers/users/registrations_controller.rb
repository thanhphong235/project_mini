class Users::RegistrationsController < Devise::RegistrationsController
  layout :choose_layout

  protected

  # -------- Layout ----------
  def choose_layout
    if user_signed_in? && current_user.admin?
      "admin"
    else
      "application"
    end
  end

  # -------- Cập nhật không cần mật khẩu ----------
  def update_resource(resource, params)
    if params[:password].present?
      resource.update_with_password(params)
    else
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  # -------- Ngăn auto login khi đăng ký ----------
  def sign_up(resource_name, resource)
    # Do nothing để ngăn tự đăng nhập
  end

  # -------- Thêm flash thông báo sau đăng ký ----------
  def after_sign_up_path_for(resource)
    flash[:notice] = "Đăng ký thành công, vui lòng đăng nhập"
    new_user_session_path
  end
end
