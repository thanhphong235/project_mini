class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_google_oauth
  end

  def facebook
    handle_auth("Facebook")
  end

  def twitter
    handle_auth("Twitter")
  end

  def failure
    redirect_to root_path, alert: "Đăng nhập thất bại, vui lòng thử lại."
  end

  private

  # Riêng Google, đảm bảo admin được update uid
  def handle_google_oauth
    auth = request.env["omniauth.auth"]

    # Tìm user theo email (cả admin và user thường)
    user = User.find_by(email: auth.info.email)

    if user
      # Cập nhật provider và uid từ Google
      user.update(provider: auth.provider, uid: auth.uid)

      # Đăng nhập
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      # Nếu chưa có user thì tạo mới
      user = User.from_omniauth(auth)
      if user.persisted?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      else
        session["devise.google_data"] = auth.except("extra")
        redirect_to new_user_registration_url, alert: "Đăng nhập bằng Google thất bại."
      end
    end
  end

  # Xử lý chung cho Facebook/Twitter
  def handle_auth(kind)
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session["devise.#{kind.downcase}_data"] = auth.except("extra")
      redirect_to new_user_registration_url, alert: "Đăng nhập bằng #{kind} thất bại."
    end
  end
end
