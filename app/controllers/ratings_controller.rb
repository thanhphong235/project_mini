class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_drink, only: [:new, :create]
  before_action :set_rating, only: [:update, :destroy]

  # GET /food_drinks/:food_drink_id/ratings/new
  def new
    @rating = @food_drink.ratings.find_or_initialize_by(user: current_user)
    render partial: "ratings/form", locals: { rating: @rating, food_drink: @food_drink }
  end

  # POST /food_drinks/:food_drink_id/ratings
  def create
    @rating = @food_drink.ratings.find_or_initialize_by(user: current_user)
    @rating.assign_attributes(rating_params)

    if @rating.save
      flash.now[:notice] = "Đánh giá đã được gửi!"
    else
      flash.now[:alert] = @rating.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_streams_for(@rating) }
      format.html { redirect_to food_drink_path(@food_drink) }
    end
  end

  # PATCH /ratings/:id
  def update
    if @rating.update(rating_params)
      flash.now[:notice] = "Đánh giá đã được cập nhật!"
    else
      flash.now[:alert] = @rating.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_streams_for(@rating) }
      format.html { redirect_to food_drink_path(@rating.food_drink) }
    end
  end

  # DELETE /ratings/:id
  def destroy
    food_drink = @rating.food_drink
    @rating.destroy
    flash.now[:notice] = "Đánh giá đã được xóa!"

    # Tạo rating rỗng cho form
    new_rating = food_drink.ratings.find_or_initialize_by(user: current_user)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("user_rating_form", partial: "ratings/form", locals: { rating: new_rating, food_drink: food_drink }),
          turbo_stream.replace("ratings_list", partial: "ratings/list", locals: { ratings: food_drink.ratings.includes(:user) }),
          turbo_stream.replace("flash_messages", partial: "shared/flash")
        ]
      end
      format.html { redirect_to food_drink_path(food_drink) }
    end
  end

  private

  def set_food_drink
    @food_drink = FoodDrink.find(params[:food_drink_id])
  end

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:score, :comment)
  end

  # Turbo stream helper
  def turbo_streams_for(rating)
    food_drink = rating.food_drink
    [
      turbo_stream.replace("user_rating_form", partial: "ratings/form", locals: { rating: rating, food_drink: food_drink }),
      turbo_stream.replace("ratings_list", partial: "ratings/list", locals: { ratings: food_drink.ratings.includes(:user) }),
      turbo_stream.replace("flash_messages", partial: "shared/flash")
    ]
  end
end
