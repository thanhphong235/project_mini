class Admin::FoodDrinksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_food_drink, only: [:edit, :update, :destroy]

  # GET /admin/food_drinks
  def index
    @food_drinks = FoodDrink.all

    # Lọc theo category
    @food_drinks = @food_drinks.where(category_id: params[:category_id]) if params[:category_id].present?

    # Tìm kiếm theo tên (không phân biệt hoa thường)
    if params[:query].present?
      keyword = "%#{params[:query].strip}%"
      @food_drinks = @food_drinks.where("name ILIKE ?", keyword)
    end

    # Sắp xếp
    @food_drinks = case params[:sort]
                   when "name_asc" then @food_drinks.order(name: :asc)
                   when "name_desc" then @food_drinks.order(name: :desc)
                   when "price_asc" then @food_drinks.order(price: :asc)
                   when "price_desc" then @food_drinks.order(price: :desc)
                   else @food_drinks.order(created_at: :desc)
                   end
  end

  # GET /admin/food_drinks/new
  def new
    @food_drink = FoodDrink.new
  end

  # POST /admin/food_drinks
  def create
    @food_drink = FoodDrink.new(food_drink_params)

    if @food_drink.save
      flash.now[:notice] = "Thêm món ăn/thức uống thành công!"
      respond_to do |format|
        format.html { redirect_to admin_food_drinks_path, notice: flash[:notice] }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("food_drink_form", partial: "form", locals: { food_drink: @food_drink }) }
      end
    end
  end

  # GET /admin/food_drinks/:id/edit
  def edit; end

  # PATCH/PUT /admin/food_drinks/:id
def update
  if @food_drink.update(food_drink_params)
    flash.now[:notice] = "Món ăn/thức uống đã được cập nhật."

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("flash_messages", partial: "shared/flash"),
          turbo_stream.replace("food_drink_form", partial: "admin/food_drinks/form", locals: { food_drink: @food_drink })
        ]
      end
      format.html { redirect_to edit_admin_food_drink_path(@food_drink), notice: "Món ăn/thức uống đã được cập nhật." }
    end
  else
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "food_drink_form",
          partial: "admin/food_drinks/form",
          locals: { food_drink: @food_drink }
        )
      end
      format.html { render :edit, status: :unprocessable_entity }
    end
  end
end
  # DELETE /admin/food_drinks/:id
  def destroy
    if @food_drink.destroy
      flash[:notice] = "Đã xoá món ăn/thức uống."
      respond_to do |format|
        format.html { redirect_to admin_food_drinks_path }
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@food_drink) }
      end
    end
  rescue ActiveRecord::InvalidForeignKey
    flash[:alert] = "Không thể xoá món ăn/thức uống vì đang có đơn hàng liên quan."
    redirect_to admin_food_drinks_path
  end

  # DELETE /admin/food_drinks/bulk_delete
  def bulk_delete
    ids = params.dig(:food_drink, :food_drink_ids) || []

    if ids.any?
      FoodDrink.where(id: ids).destroy_all
      flash[:notice] = "Đã xoá các món đã chọn."
    else
      flash[:alert] = "Bạn chưa chọn món nào để xoá."
    end
    redirect_to admin_food_drinks_path
  rescue ActiveRecord::InvalidForeignKey
    flash[:alert] = "Không thể xoá vì một số món đang có đơn hàng liên quan."
    redirect_to admin_food_drinks_path
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
