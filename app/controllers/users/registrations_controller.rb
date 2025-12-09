class Users::RegistrationsController < Devise::RegistrationsController
  layout :choose_layout

  protected

  # Chọn layout theo vai trò user
  def choose_layout
    if user_signed_in? && current_user.admin?
      "admin"      # layout dành cho admin
    else
      "application" # layout mặc định cho user
    end
  end

  # Cho phép cập nhật mà không cần mật khẩu
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
end
