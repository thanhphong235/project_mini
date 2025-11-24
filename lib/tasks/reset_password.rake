namespace :devise do
  desc "Xóa tất cả token reset password cũ và gửi lại email reset password"
  task reset_all_password_tokens: :environment do
    puts "=== Xóa tất cả reset_password_token cũ ==="
    User.update_all(reset_password_token: nil, reset_password_sent_at: nil)
    puts "Đã xóa xong."

    puts "=== Gửi lại email reset password mới ==="
    User.find_each do |user|
      user.send_reset_password_instructions
      puts "Đã gửi email cho: #{user.email}, token hết hạn sau #{Devise.reset_password_within.inspect}"
    end

    puts "=== Hoàn tất ==="
  end
end
