class FoodDrinksController < ApplicationController
  before_action :set_food_drink, only: [:show]

  # GET /food_drinks
  def index
    # --- Toàn bộ món để tính giá min/max placeholder ---
    all_food_drinks = FoodDrink.all
    @min_price = all_food_drinks.minimum(:price)
    @max_price = all_food_drinks.maximum(:price)

    # --- Danh sách món đã filter ---
    @food_drinks = all_food_drinks.includes(:category, :ratings)

    # Filter theo category
    @food_drinks = @food_drinks.where(category_id: params[:category_id]) if params[:category_id].present?

    # Filter theo loại (Food / Drink)
    @food_drinks = @food_drinks.where(kind: params[:kind]) if params[:kind].present?

    # Filter theo giá
    if params[:min_price].present?
      min_price = normalize_price(params[:min_price])
      @food_drinks = @food_drinks.where("price >= ?", min_price) if min_price
    end

    if params[:max_price].present?
      max_price = normalize_price(params[:max_price])
      @food_drinks = @food_drinks.where("price <= ?", max_price) if max_price
    end

    # Tìm kiếm theo tên
    if params[:query].present?
      query = "%#{params[:query].downcase}%"
      @food_drinks = @food_drinks.where("LOWER(name) LIKE ?", query)
    end

    # Lọc theo đánh giá trung bình
    if params[:min_rating].present?
      @food_drinks = @food_drinks
        .left_joins(:ratings)
        .group("food_drinks.id")
        .having("COALESCE(AVG(ratings.score), 0) >= ?", params[:min_rating].to_f)
    end

    # Sắp xếp theo sort_by
    @food_drinks = case params[:sort_by]
                   when "price_asc"
                     @food_drinks.order(price: :asc)
                   when "price_desc"
                     @food_drinks.order(price: :desc)
                   else
                     @food_drinks.order(:name) # Mặc định A-Z
                   end

    # --- Phản hồi ---
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "food_drinks_list",
          partial: "food_drinks/list",
          locals: { food_drinks: @food_drinks }
        )
      end
    end
  end

  # GET /food_drinks/:id
  def show
    @food_drink = FoodDrink.find(params[:id])
    @rating = @food_drink.ratings.find_or_initialize_by(user: current_user)
  end


  private

  def set_food_drink
    @food_drink = FoodDrink.find(params[:id])
  end

  # Chuyển chuỗi giá VN/US thành số
  def normalize_price(price_str)
    return nil unless price_str.present?

    price_str = price_str.to_s.strip
    if price_str.match?(/\d+[.,]\d{3}[.,]\d{1,2}/) # VN: 1.234,56
      price_str.gsub('.', '').gsub(',', '.').to_f
    else # US: 1,234.56 hoặc 1200
      price_str.gsub(',', '').to_f
    end
  end
end
