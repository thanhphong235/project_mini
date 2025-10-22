class Admin::FoodDrinksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_food_drink, only: [:edit, :update, :destroy]

  def index
    if params[:category_id].present?
      @food_drinks = FoodDrink.where(category_id: params[:category_id])
    else
      @food_drinks = FoodDrink.all
    end
  end

  def new
    @food_drink = FoodDrink.new
  end

  def create
    @food_drink = FoodDrink.new(food_drink_params)
    if @food_drink.save
      redirect_to admin_food_drinks_path, notice: "Món ăn/thức uống đã được tạo."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @food_drink.update(food_drink_params)
      redirect_to admin_food_drinks_path, notice: "Món ăn/thức uống đã được cập nhật."
    else
      render :edit
    end
  end

  def destroy
    @food_drink.destroy
    redirect_to admin_food_drinks_path, notice: "Đã xoá món ăn/thức uống."
  end

  private

  def set_food_drink
    @food_drink = FoodDrink.find(params[:id])
  end

  def food_drink_params
    params.require(:food_drink).permit(:name, :price, :description, :image, :category_id)
  end

  def require_admin
    redirect_to root_path, alert: "Bạn không có quyền truy cập trang này." unless current_user&.admin?
  end
end
