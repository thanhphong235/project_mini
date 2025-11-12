class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_drink
  before_action :set_rating, only: %i[edit update destroy]

  # POST /food_drinks/:food_drink_id/ratings
  def create
    # Nếu user đã đánh giá trước đó, dùng find_or_initialize_by để update
    @rating = @food_drink.ratings.find_or_initialize_by(user: current_user)
    @rating.assign_attributes(rating_params)

    if @rating.save
      # Tạo form trống mới để reset
      @new_rating = @food_drink.ratings.new(user: current_user)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "user_rating_form", # id của div chứa form
            partial: "ratings/form",
            locals: { food_drink: @food_drink, rating: @new_rating }
          ) +
          turbo_stream.replace(
            "ratings_list", # id chứa danh sách đánh giá
            partial: "ratings/list",
            locals: { ratings: @food_drink.ratings.reload }
          )
        end
        format.html { redirect_to @food_drink, notice: "Đánh giá đã được gửi." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "user_rating_form",
            partial: "ratings/form",
            locals: { food_drink: @food_drink, rating: @rating }
          )
        end
        format.html { render "food_drinks/show", status: :unprocessable_entity }
      end
    end
  end

  # GET /food_drinks/:food_drink_id/ratings/:id/edit
  def edit
    # Khi nhấn cập nhật, form hiển thị dữ liệu cũ
    render turbo_stream: turbo_stream.replace(
      "user_rating_form",
      partial: "ratings/form",
      locals: { food_drink: @food_drink, rating: @rating }
    )
  end

  # PATCH /food_drinks/:food_drink_id/ratings/:id
  def update
    if @rating.update(rating_params)
      @rating_form = @food_drink.ratings.new(user: current_user)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @food_drink, notice: "Đánh giá đã được cập nhật." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "user_rating_form",
            partial: "ratings/form",
            locals: { food_drink: @food_drink, rating: @rating }
          )
        end
        format.html { render "food_drinks/show", status: :unprocessable_entity }
      end
    end
  end

  # DELETE /food_drinks/:food_drink_id/ratings/:id
  def destroy
    @rating.destroy
    @rating_form = @food_drink.ratings.new(user: current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @food_drink, notice: "Đánh giá đã được xóa." }
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
end
