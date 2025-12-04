class Admin::FoodDrinksController < Admin::BaseController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_food_drink, only: [:edit, :update, :destroy]

  # GET /admin/food_drinks
  def index
    @food_drinks = FoodDrink.all

    @food_drinks = @food_drinks.where(category_id: params[:category_id]) if params[:category_id].present?

    if params[:query].present?
      keyword = "%#{params[:query].strip}%"
      @food_drinks = @food_drinks.where("name ILIKE ?", keyword)
    end

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

    respond_to do |format|
      if @food_drink.save
        format.html { redirect_to new_admin_food_drink_path, notice: "Thêm món ăn/thức uống thành công!" }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("food_drink_form", partial: "admin/food_drinks/form", locals: { food_drink: FoodDrink.new }),
            turbo_stream.replace("flash_messages", partial: "shared/flash", locals: { notice: "Thêm món ăn/thức uống thành công!" })
          ]
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "food_drink_form",
            partial: "admin/food_drinks/form",
            locals: { food_drink: @food_drink }
          )
        end
      end

    end
  end

  # GET /admin/food_drinks/:id/edit
  def edit; end

  # PATCH/PUT /admin/food_drinks/:id
  def update
    respond_to do |format|
      if @food_drink.update(food_drink_params)
        format.html { redirect_to edit_admin_food_drink_path(@food_drink), notice: "Món ăn/thức uống đã được cập nhật." }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("food_drink_form", partial: "admin/food_drinks/form", locals: { food_drink: @food_drink }),
            turbo_stream.replace("flash_messages", partial: "shared/flash", locals: { notice: "Món ăn/thức uống đã được cập nhật." })
          ]
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "food_drink_form",
            partial: "admin/food_drinks/form",
            locals: { food_drink: @food_drink }
          )
        end
      end
    end
  end

  # DELETE /admin/food_drinks/:id
  def destroy
    if @food_drink.destroy
      respond_to do |format|
        format.html { redirect_to admin_food_drinks_path, notice: "Đã xoá món ăn/thức uống." }
        format.turbo_stream { render turbo_stream: turbo_stream.remove(helpers.dom_id(@food_drink)) }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_food_drinks_path, alert: "Không thể xoá món ăn/thức uống." }
        format.turbo_stream do
          flash.now[:alert] = "Không thể xoá món ăn/thức uống."
          render turbo_stream: turbo_stream.replace("flash_messages", partial: "shared/flash")
        end
      end
    end
  rescue ActiveRecord::InvalidForeignKey
    respond_to do |format|
      format.html { redirect_to admin_food_drinks_path, alert: "Không thể xoá món ăn/thức uống vì đang có đơn hàng liên quan." }
      format.turbo_stream do
        flash.now[:alert] = "Không thể xoá món ăn/thức uống vì đang có đơn hàng liên quan."
        render turbo_stream: turbo_stream.replace("flash_messages", partial: "shared/flash")
      end
    end
  end

  # DELETE /admin/food_drinks/bulk_delete
def bulk_delete
  ids = params.dig(:food_drink, :food_drink_ids) || []

  if ids.blank?
    respond_to do |format|
      format.html do
        redirect_to admin_food_drinks_path, alert: "Bạn chưa chọn món nào để xoá."
      end

      format.turbo_stream do
        flash.now[:alert] = "Bạn chưa chọn món nào để xoá."
        render turbo_stream: turbo_stream.replace("flash_messages", partial: "shared/flash")
      end
    end
    return
  end

  begin
    # Destroy each, collect DOM ids
    deleted_ids = []
    FoodDrink.where(id: ids).find_each do |fd|
      if fd.destroy
        deleted_ids << "food_drink_#{fd.id}" # <-- fix dom_id issue
      end
    end

    respond_to do |format|
      format.html do
        flash[:notice] = "Đã xoá #{deleted_ids.size} món."
        redirect_to admin_food_drinks_path
      end

      format.turbo_stream do
        flash.now[:notice] = "Đã xoá #{deleted_ids.size} món."
        streams = deleted_ids.map { |dom| turbo_stream.remove(dom) }
        streams << turbo_stream.replace("flash_messages", partial: "shared/flash")
        render turbo_stream: streams
      end
    end
  rescue ActiveRecord::InvalidForeignKey
    respond_to do |format|
      format.html { redirect_to admin_food_drinks_path, alert: "Không thể xoá vì một số món đang có đơn hàng liên quan." }
      format.turbo_stream do
        flash.now[:alert] = "Không thể xoá vì một số món đang có đơn hàng liên quan."
        render turbo_stream: turbo_stream.replace("flash_messages", partial: "shared/flash")
      end
    end
  end
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