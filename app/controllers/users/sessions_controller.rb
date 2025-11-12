class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by(email: sign_in_params[:email])

    if user&.provider.present? && user.provider != 'email'
      provider_name = user.provider.capitalize
      flash.now[:alert] = "Tài khoản này chỉ có thể đăng nhập bằng #{provider_name}."
      # tạo một resource mới để Devise render lại form
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      # render trực tiếp form login thay vì dùng respond_with
      render :new, status: :unprocessable_entity
    else
      super
    end
  end

  protected

  # tránh lỗi redirect users_url
  def after_sign_in_path_for(resource)
    root_path # hoặc đổi thành dashboard_path, foods_drinks_path...
  end
end
