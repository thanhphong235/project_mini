class RatingsController < ApplicationController
  before_action :authenticate_user!

  def create
    fd = FoodDrink.find(params[:food_drink_id])
    rating = fd.ratings.new(rating_params.merge(user: current_user))
    if rating.save
      redirect_back fallback_location: food_drink_path(fd), notice: "Đã đánh giá."
    else
      redirect_back fallback_location: food_drink_path(fd), alert: "Không thể đánh giá."
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:score, :comment)
  end
end
