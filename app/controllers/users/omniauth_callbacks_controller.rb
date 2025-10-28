class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Google OAuth2
  def google_oauth2
    handle_oauth("Google")
  end

  # Facebook OAuth
  def facebook
    handle_oauth("Facebook")
  end

  # Twitter OAuth
  def twitter
    handle_oauth("Twitter")
  end

  # Khi OAuth thất bại
  def failure
    redirect_to root_path, alert: "Đăng nhập thất bại, vui lòng thử lại."
  end

  private

  # Xử lý chung cho tất cả OAuth
  def handle_oauth(kind)
    auth = request.env["omniauth.auth"]

    # Tìm user theo email (hoặc provider+uid nếu cần)
    user = User.find_by(email: auth.info.email)

    if user
      # Cập nhật provider/uid
      user.update(provider: auth.provider, uid: auth.uid)
    else
      # Tạo mới user nếu chưa có
      user = User.from_omniauth(auth)
    end

    if user.persisted?
      sign_in(user, event: :authentication)
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
      # Không redirect ở đây, Devise sẽ dùng after_sign_in_path_for
    else
      session["devise.#{kind.downcase}_data"] = auth.except("extra")
      redirect_to new_user_registration_url, alert: "Đăng nhập bằng #{kind} thất bại."
    end
  end
end
