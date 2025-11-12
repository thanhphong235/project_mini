# config/initializers/admin_test.rb
if Rails.env.production?
  admin_email = "admin_test@example.com"
  admin_password = "123456"

  admin = User.find_or_initialize_by(email: admin_email)
  admin.name = "Admin Test"
  admin.role = "admin"
  admin.password = admin_password
  admin.password_confirmation = admin_password
  admin.confirmed_at = Time.current if admin.respond_to?(:confirmed_at)
  
  if admin.save
    puts admin.previously_new_record? ? "✅ Admin test mới tạo!" : "⚠️ Admin test đã tồn tại, password reset!"
  else
    puts "❌ Lỗi tạo admin test: #{admin.errors.full_messages.join(', ')}"
  end
end
