# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  # POST /users/sign_in
  def create
    self.resource = User.find_by(email: sign_in_params[:email])

    if resource.nil?
      # user không tồn tại → trả về form với alert
      flash.now[:alert] = "Email không tồn tại."
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      render :new, status: :unprocessable_entity
      return
    end

    if resource.provider.present? && resource.provider != 'email'
      provider_name = resource.provider.capitalize
      flash.now[:alert] = "Tài khoản này chỉ có thể đăng nhập bằng #{provider_name}."
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      render :new, status: :unprocessable_entity
      return
    end

    # Devise đăng nhập bình thường
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)

    respond_to do |format|
      format.html { redirect_to after_sign_in_path_for(resource) }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("flash_messages", partial: "shared/flash") }
    end
  end

  protected

  # Redirect sau khi đăng nhập
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      root_path # hoặc food_drinks_path nếu là user
    end
  end
end
