class FoodDrinksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @categories = FoodDrink.distinct.pluck(:category) # lấy danh sách loại
    @food_drinks = FoodDrink.all

    # Lọc theo category (VD: "Food", "Drink")
    if params[:category].present?
      @food_drinks = @food_drinks.where(category: params[:category])
    end

    # Lọc theo từ khóa tìm kiếm (nếu có)
    if params[:search].present?
      keyword = "%#{params[:search]}%"
      @food_drinks = @food_drinks.where("name LIKE ? OR description LIKE ?", keyword, keyword)
    end
  end

  def show
    @food_drink = FoodDrink.find(params[:id])
  end

  def new
    @food_drink = FoodDrink.new
  end

  def create
    @food_drink = FoodDrink.new(food_drink_params)
    if @food_drink.save
      redirect_to @food_drink, notice: "Đã thêm thành công!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @food_drink = FoodDrink.find(params[:id])
  end

  def update
    @food_drink = FoodDrink.find(params[:id])
    if @food_drink.update(food_drink_params)
      redirect_to @food_drink, notice: "Cập nhật thành công!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @food_drink = FoodDrink.find(params[:id])
    @food_drink.destroy
    redirect_to food_drinks_path, notice: "Đã xoá món ăn/thức uống."
  end

  private

  def food_drink_params
    params.require(:food_drink).permit(:name, :description, :category, :price, :image)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to food_drinks_path, alert: "Bạn không có quyền thực hiện hành động này."
    end
  end
end
