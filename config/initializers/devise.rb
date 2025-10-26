# frozen_string_literal: true

Devise.setup do |config|
  # Email gửi mặc định
  config.mailer_sender = 'no-reply@foodsdrinksapp.com'

  # Sử dụng ActiveRecord cho Devise
  require 'devise/orm/active_record'

  # Cấu hình xác thực
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # Lưu session
  config.skip_session_storage = [:http_auth]

  # Bảo mật mật khẩu
  config.stretches = Rails.env.test? ? 1 : 12

  # Xác nhận email (nếu bật confirmable)
  config.reconfirmable = true

  # Độ dài mật khẩu
  config.password_length = 6..128

  # Kiểm tra định dạng email
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # Đăng xuất qua method DELETE
  config.sign_out_via = :delete

  # Các trạng thái phản hồi khi dùng Turbo/Hotwire
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # ==> Cấu hình OmniAuth (Đăng nhập qua MXH)
  # Facebook
  config.omniauth :facebook,
                  ENV["FACEBOOK_APP_ID"],
                  ENV["FACEBOOK_APP_SECRET"],
                  scope: 'email',
                  info_fields: 'email,name'

  # Google
  config.omniauth :google_oauth2, "YOUR_CLIENT_ID", "YOUR_CLIENT_SECRET", scope: 'email,profile'

  # Twitter (cần sửa lại một chút — Twitter API không dùng `scope` trong OAuth 1.0a)
  config.omniauth :twitter,
                  ENV["TWITTER_API_KEY"],
                  ENV["TWITTER_API_SECRET"]

  # Cấu hình bảo mật khác
  config.clean_up_csrf_token_on_authentication = true
  config.expire_all_remember_me_on_sign_out = true
  config.reset_password_within = 6.hours
end
