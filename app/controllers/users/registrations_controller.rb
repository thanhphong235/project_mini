class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Cho phép cập nhật mà không cần mật khẩu
  def update_resource(resource, params)
    if params[:password].present?
      # Nếu có nhập mật khẩu mới thì cập nhật như bình thường
      resource.update_with_password(params)
    else
      # Nếu không có mật khẩu thì bỏ qua xác thực mật khẩu
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end
  def after_update_path_for(resource)
    edit_user_registration_path # ở lại trang edit
  end
end
