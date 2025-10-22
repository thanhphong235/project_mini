class FoodDrinksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_food_drink, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
    @food_drinks = FoodDrink.includes(:category).all

    # Lọc theo category_id
    if params[:category_id].present?
      @food_drinks = @food_drinks.where(category_id: params[:category_id])
    end

    # Lọc theo từ khóa tìm kiếm
    if params[:search].present?
      keyword = "%#{params[:search]}%"
      @food_drinks = @food_drinks.where("name LIKE ? OR description LIKE ?", keyword, keyword)
    end
  end

  def show
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
  end

  def update
    if @food_drink.update(food_drink_params)
      redirect_to @food_drink, notice: "Cập nhật thành công!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @food_drink.destroy
    redirect_to food_drinks_path, notice: "Đã xoá món ăn/thức uống."
  end

  private

  def set_food_drink
    @food_drink = FoodDrink.find(params[:id])
  end

  def food_drink_params
    # Lưu ý: dùng category_id thay vì category string
    params.require(:food_drink).permit(:name, :description, :price, :image, :category_id)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to food_drinks_path, alert: "Bạn không có quyền thực hiện hành động này."
    end
  end
end
