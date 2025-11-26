# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Cho phép thêm trường name khi đăng ký & cập nhật
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # Sau khi đăng nhập, redirect theo loại user
  def after_sign_in_path_for(resource)
    # root_path
     if resource.admin?
       admin_dashboard_path   # Admin → vào trang admin
     else
        root_path
    #   food_drinks_path       # User → vào trang food & drinks
     end
  end

  # Sau khi đăng xuất, quay về trang chủ
  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
  def run_seed
    if Rails.env.production?
      begin
        require 'active_record'

        # ✅ Kiểm tra DB đã có bảng food_drinks chưa
        if ActiveRecord::Base.connection.data_source_exists?('food_drinks')
          # ✅ Chỉ chạy nếu chưa có món ăn nào
          if FoodDrink.count == 0
            load Rails.root.join("db/seeds.rb")
            render plain: "✅ Seed database đã chạy trên production!"
          else
            render plain: "⚠️ Database đã có dữ liệu. Seed không chạy."
          end
        else
          render plain: "❌ Database chưa sẵn sàng."
        end
      rescue => e
        render plain: "❌ Lỗi khi chạy seed: #{e.message}"
      end
    else
      render plain: "❌ Chỉ chạy trên production"
    end
  end
end
