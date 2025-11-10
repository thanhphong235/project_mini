class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_drink
  before_action :set_rating, only: [:update, :destroy]

  # POST /food_drinks/:food_drink_id/ratings
  def create
    @rating = @food_drink.ratings.find_or_initialize_by(user: current_user)
    @rating.assign_attributes(rating_params)

    if @rating.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "user_rating_form",
              partial: "ratings/form",
              locals: { food_drink: @food_drink, rating: @rating }
            ),
            turbo_stream.replace(
              "ratings_list",
              partial: "ratings/list",
              locals: { ratings: @food_drink.ratings.includes(:user) }
            ),
            turbo_stream.replace(
              "flash_messages",
              partial: "shared/flash"
            ),
            # Gọi lại JS khởi tạo sao sau khi frame được thay thế
            turbo_stream.append(
              "user_rating_form",
              "<script>initStarRating(document.querySelector('#user_rating_form'))</script>".html_safe
            )
          ]
        end
      end
    else
      render partial: "ratings/form", locals: { food_drink: @food_drink, rating: @rating }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /food_drinks/:food_drink_id/ratings/:id
  def update
    if @rating.update(rating_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "user_rating_form",
              partial: "ratings/form",
              locals: { food_drink: @food_drink, rating: @rating }
            ),
            turbo_stream.replace(
              "ratings_list",
              partial: "ratings/list",
              locals: { ratings: @food_drink.ratings.includes(:user) }
            ),
            turbo_stream.replace(
              "flash_messages",
              partial: "shared/flash"
            ),
            # Gọi lại JS để kích hoạt sao vàng
            turbo_stream.append(
              "user_rating_form",
              "<script>initStarRating(document.querySelector('#user_rating_form'))</script>".html_safe
            )
          ]
        end
      end
    else
      render partial: "ratings/form", locals: { food_drink: @food_drink, rating: @rating }, status: :unprocessable_entity
    end
  end

  # DELETE /food_drinks/:food_drink_id/ratings/:id
  def destroy
    @rating.destroy
    new_rating = @food_drink.ratings.find_or_initialize_by(user: current_user)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "user_rating_form",
            partial: "ratings/form",
            locals: { food_drink: @food_drink, rating: new_rating }
          ),
          turbo_stream.replace(
            "ratings_list",
            partial: "ratings/list",
            locals: { ratings: @food_drink.ratings.includes(:user) }
          ),
          turbo_stream.replace("flash_messages", partial: "shared/flash"),
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
end
