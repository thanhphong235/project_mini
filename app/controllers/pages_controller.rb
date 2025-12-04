class PagesController < ApplicationController
  def home
    # Nếu đã đăng nhập → redirect đúng role
    if user_signed_in?
      if current_user.admin?
        return redirect_to admin_dashboard_path
      else
        return redirect_to food_drinks_path
      end
    end

    # Nếu chưa đăng nhập → hiển thị trang home bình thường
    @categories = Category.all
    @selected_category = params[:category_id]

    @food_drinks = FoodDrink.all
    @food_drinks = @food_drinks.where(category_id: @selected_category) if @selected_category.present?
  end
end
