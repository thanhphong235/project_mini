# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_oauth("Google")
  end

  def facebook
    handle_oauth("Facebook")
  end

  def twitter
    handle_oauth("Twitter")
  end

  def failure
    redirect_to root_path, alert: "Đăng nhập thất bại, vui lòng thử lại."
  end

  private

  def handle_oauth(provider_name)
    auth = request.env["omniauth.auth"]

    # Tìm user theo provider+uid hoặc email
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) if auth.info.email.present?

    # Nếu không có, tạo mới
    user ||= User.from_omniauth(auth)

    if user.persisted?
      sign_in(user, event: :authentication)
      flash[:notice] = "Đăng nhập thành công bằng #{provider_name}" if is_navigational_format?
      redirect_to after_sign_in_path_for(user)  # sẽ phân biệt admin & user
    else
      session["devise.#{provider_name.downcase}_data"] = auth.except("extra")
      redirect_to new_user_registration_url, alert: "Đăng nhập bằng #{provider_name} thất bại."
    end
  end
end
