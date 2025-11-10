class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_drink
  before_action :set_rating, only: [:update, :destroy]

  # POST /food_drinks/:food_drink_id/ratings
  def create
    @rating = @food_drink.ratings.find_or_initialize_by(user: current_user)
    @rating.assign_attributes(rating_params)

    if @rating.save
      render_turbo_stream
    else
      render :new
    end
  end

  # PATCH/PUT /food_drinks/:food_drink_id/ratings/:id
  def update
    @rating.assign_attributes(rating_params)

    if @rating.save
      render_turbo_stream
    else
      render :edit
    end
  end

  # DELETE /food_drinks/:food_drink_id/ratings/:id
  def destroy
    @rating = @food_drink.ratings.find(params[:id])
    @rating.destroy

    respond_to do |format|
      format.turbo_stream do
        rating = @food_drink.ratings.find_or_initialize_by(user: current_user)
        render turbo_stream: [
          turbo_stream.replace(
            "user_rating_form",
            partial: "ratings/form",
            locals: { rating: rating, food_drink: @food_drink }
          ),
          turbo_stream.replace("ratings_list", partial: "ratings/list", locals: { ratings: @food_drink.ratings.includes(:user) }),
          turbo_stream.replace("flash_messages", partial: "shared/flash"),
          # thêm line này để gọi init JS sau khi frame replace
          turbo_stream.append(
            "user_rating_form",
            "<script>initStarRating(document.querySelector('#user_rating_form'))</script>".html_safe
          )
        ]
      end
    end
  end


  private

  def set_food_drink
    @food_drink = FoodDrink.find(params[:food_drink_id])
  end

  def set_rating
    @rating = @food_drink.ratings.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:score, :comment)
  end

  # Gửi turbo_stream để cập nhật form, danh sách ratings và flash
  def render_turbo_stream
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("user_rating_form", partial: "ratings/form", locals: { rating: @rating, food_drink: @food_drink }),
          turbo_stream.replace("ratings_list", partial: "ratings/list", locals: { ratings: @food_drink.ratings.includes(:user) }),
          turbo_stream.replace("flash_messages", partial: "shared/flash")
        ]
      end
    end
  end
end
