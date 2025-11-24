class Users::PasswordsController < Devise::PasswordsController
  # POST /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message!(:notice, flash_message)
      sign_in(resource_name, resource)
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      if resource.errors.details[:reset_password_token].any? { |e| e[:error] == :expired }
        flash[:alert] = "Link đặt lại mật khẩu đã hết hạn. Vui lòng yêu cầu gửi lại email."
        redirect_to new_user_password_path
      else
        respond_with resource
      end
    end
  end
end
