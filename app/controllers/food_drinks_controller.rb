class FoodDrinksController < ApplicationController
  before_action :set_food_drink, only: [:show]

  # GET /food_drinks
  def index
    @food_drinks = FoodDrink.all.includes(:category)

    # Lọc theo category nếu có params
    if params[:category_id].present?
      @food_drinks = @food_drinks.where(category_id: params[:category_id])
    end

    # Có thể mở rộng filter khác sau này (giá, chữ cái...)    
  end

  # GET /food_drinks/:id
  def show
    # Chuẩn bị rating mới để form gửi đánh giá
    if user_signed_in?
      @rating = @food_drink.ratings.find_or_initialize_by(user: current_user)
    end
  end

  private

  def set_food_drink
    @food_drink = FoodDrink.find(params[:id])
  end
end
