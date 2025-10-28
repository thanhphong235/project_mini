# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Google callback
  def google_oauth2
    handle_oauth("Google")
  end

  # Facebook callback
  def facebook
    handle_oauth("Facebook")
  end

  # Twitter callback
  def twitter
    handle_oauth("Twitter")
  end

  # Nếu login thất bại
  def failure
    redirect_to root_path, alert: "Đăng nhập thất bại, vui lòng thử lại."
  end

  private

  def handle_oauth(provider_name)
    auth = request.env["omniauth.auth"]

    # Tìm user theo email nếu có (Google/Facebook), hoặc tạo mới
    user = User.find_by(email: auth.info.email) if auth.info.email.present?

    user ||= User.from_omniauth(auth)

    if user.persisted?
      # Đăng nhập user và redirect theo after_sign_in_path_for
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      # Nếu user không save được, lưu dữ liệu tạm và redirect đến đăng ký
      session["devise.#{provider_name.downcase}_data"] = auth.except("extra")
      redirect_to new_user_registration_url, alert: "Đăng nhập bằng #{provider_name} thất bại."
    end
  end
end
