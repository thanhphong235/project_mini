# config/initializers/admin_test.rb
# ❌ Chỉ chạy khi không precompile assets
if Rails.env.production? && ENV["RUNNING_ASSET_PRECOMPILE"].blank?
  Rails.application.config.after_initialize do
    admin_email = "admin_test@example.com"
    admin_password = "123456"

    admin = User.find_or_initialize_by(email: admin_email)
    admin.name = "Admin Test"
    admin.role = "admin"
    admin.password = admin_password
    admin.password_confirmation = admin_password
    admin.confirmed_at = Time.current if admin.respond_to?(:confirmed_at)
    admin.save!
  end
end
