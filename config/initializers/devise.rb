# frozen_string_literal: true

Devise.setup do |config|
  # Email gửi mặc định từ Devise
  config.mailer_sender = 'no-reply@foodsdrinksapp.com'

  # Sử dụng ActiveRecord ORM
  require 'devise/orm/active_record'

  # OmniAuth providers
  require 'omniauth-google-oauth2'
  # Facebook và Twitter sẽ require khi cần
  require 'omniauth-facebook'
  require 'omniauth-twitter'

  # ==> Cấu hình cơ bản Devise
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.sign_out_via = :delete
  config.clean_up_csrf_token_on_authentication = true
  config.expire_all_remember_me_on_sign_out = true
  config.reset_password_within = 6.hours

  # Turbo/Hotwire
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  # ==> OmniAuth configuration
  # Facebook
  config.omniauth :facebook,
                  ENV['FACEBOOK_APP_ID'],
                  ENV['FACEBOOK_APP_SECRET'],
                  scope: 'email',
                  info_fields: 'email,name'

  # Google
# Google
  config.omniauth :google_oauth2,
                  ENV['GOOGLE_CLIENT_ID'],
                  ENV['GOOGLE_CLIENT_SECRET'],
                  {
                    scope: 'email,profile',
                    prompt: 'select_account',
                    provider_ignores_state: true
                  }



                  # redirect_uri: 'http://localhost:3000/users/auth/google_oauth2/callback'

  # Twitter (OAuth 1.0a, không cần scope)
  config.omniauth :twitter,
                  ENV['TWITTER_API_KEY'],
                  ENV['TWITTER_API_SECRET']
                  

  # ==> Security & session cleanup
  # config.clean_up_csrf_token_on_authentication = true
  # config.expire_all_remember_me_on_sign_out = true
  # config.reset_password_within = 6.hours
end
