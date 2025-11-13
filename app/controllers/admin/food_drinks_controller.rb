class Admin::FoodDrinksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_food_drink, only: [:edit, :update, :destroy]

  def index
    @food_drinks = FoodDrink.all

    # Lọc theo category
    if params[:category_id].present?
      @food_drinks = @food_drinks.where(category_id: params[:category_id])
    end

    # Tìm kiếm theo tên (không phân biệt hoa thường)
    if params[:query].present?
      keyword = "%#{params[:query].strip}%"
      @food_drinks = @food_drinks.where("name ILIKE ?", keyword)
    end

    # Sắp xếp
    case params[:sort]
    when "name_asc"
      @food_drinks = @food_drinks.order(name: :asc)
    when "name_desc"
      @food_drinks = @food_drinks.order(name: :desc)
    when "price_asc"
      @food_drinks = @food_drinks.order(price: :asc)
    when "price_desc"
      @food_drinks = @food_drinks.order(price: :desc)
    else
      @food_drinks = @food_drinks.order(created_at: :desc)
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
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @food_drink.update(food_drink_params)
      redirect_to admin_food_drinks_path, notice: "Món ăn/thức uống đã được cập nhật."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @food_drink.destroy
      respond_to do |format|
        format.html { redirect_to admin_food_drinks_path, notice: "Đã xoá món ăn/thức uống." }
        format.turbo_stream
      end
    rescue ActiveRecord::InvalidForeignKey
      respond_to do |format|
        format.html { redirect_to admin_food_drinks_path, alert: "Không thể xoá món ăn/thức uống vì đang có đơn hàng liên quan." }
        format.turbo_stream do
          render turbo_stream: turbo_stream.alert("Không thể xoá món ăn/thức uống vì đang có đơn hàng liên quan.")
        end
      end
    end
  end

  # DELETE /admin/food_drinks/bulk_delete
  def bulk_delete
    ids = params[:food_drink_ids] || []
    if ids.any?
      FoodDrink.where(id: ids).destroy_all
      redirect_to admin_food_drinks_path, notice: "Đã xoá các món đã chọn."
    else
      redirect_to admin_food_drinks_path, alert: "Bạn chưa chọn món nào để xoá."
    end
  rescue ActiveRecord::InvalidForeignKey
    redirect_to admin_food_drinks_path, alert: "Không thể xoá vì một số món đang có đơn hàng liên quan."
  end

  private

  def set_food_drink
    @food_drink = FoodDrink.find(params[:id])
  end

  def food_drink_params
    params.require(:food_drink).permit(:name, :price, :description, :image, :category_id, :stock)
  end

  def require_admin
    redirect_to root_path, alert: "Bạn không có quyền truy cập trang này." unless current_user&.admin?
  end
end
