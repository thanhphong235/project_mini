class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_drink

  def create
    # Nếu user đã đánh giá món này, lấy bản ghi cũ, nếu chưa thì tạo mới
    @rating = @food_drink.ratings.find_or_initialize_by(user: current_user)
    
    if @rating.update(rating_params)
      redirect_to @food_drink, notice: "Đánh giá đã được gửi!"
    else
      redirect_to @food_drink, alert: @rating.errors.full_messages.to_sentence
    end
  end

  private

  def set_food_drink
    @food_drink = FoodDrink.find(params[:food_drink_id])
  end

  def rating_params
    params.require(:rating).permit(:score, :comment)
  end
end
