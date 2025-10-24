class FoodDrinksController < ApplicationController
  before_action :set_food_drink, only: [:show]

  # GET /food_drinks
  def index
    @food_drinks = FoodDrink.all.includes(:category, :ratings)

    # Lọc theo category
    if params[:category_id].present?
      @food_drinks = @food_drinks.where(category_id: params[:category_id])
    end

    # Lọc theo loại Food / Drink
    if params[:kind].present?
      @food_drinks = @food_drinks.where(kind: params[:kind])
    end

    # Lọc theo khoảng giá
    if params[:min_price].present?
      @food_drinks = @food_drinks.where("price >= ?", params[:min_price].to_f)
    end
    if params[:max_price].present?
      @food_drinks = @food_drinks.where("price <= ?", params[:max_price].to_f)
    end

    # Lọc theo chữ cái đầu
    if params[:letter].present?
      @food_drinks = @food_drinks.where("name LIKE ?", "#{params[:letter]}%")
    end

    # Lọc theo đánh giá trung bình
    if params[:min_rating].present?
      # LEFT JOIN để giữ cả món chưa có rating
      @food_drinks = @food_drinks
        .left_joins(:ratings)
        .group("food_drinks.id")
        .having("COALESCE(AVG(ratings.score), 0) >= ?", params[:min_rating].to_f)
    end

    # Sắp xếp theo tên chữ cái nếu muốn
    @food_drinks = @food_drinks.order(:name)
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
