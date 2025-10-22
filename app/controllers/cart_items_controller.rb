class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_item, only: [:update, :destroy]

  # GET /cart
  def index
    @cart_items = current_user.cart_items.includes(:food_drink)
      @total_price = @cart_items.sum { |item| item.food_drink.price * item.quantity }
  end

  # POST /cart_items
  def create
    food_drink = FoodDrink.find(params[:food_drink_id])

    # Nếu đã có trong giỏ thì tăng số lượng
    @cart_item = current_user.cart_items.find_or_initialize_by(food_drink: food_drink)
    @cart_item.quantity ||= 0
    @cart_item.quantity += 1

    if @cart_item.save
      respond_to do |format|
        # Khi là Turbo (bấm "Thêm vào giỏ" bằng button_to), nó sẽ tự update phần icon
        format.turbo_stream
        format.html { redirect_to cart_path, notice: "Đã thêm #{food_drink.name} vào giỏ hàng." }
      end
    else
      redirect_to food_drinks_path, alert: "Không thể thêm sản phẩm vào giỏ hàng."
    end
  end

  # PATCH /cart_items/:id
  def update
    if @cart_item.update(cart_item_params)
      redirect_to cart_path, notice: "Cập nhật giỏ hàng thành công."
    else
      redirect_to cart_path, alert: "Không thể cập nhật giỏ hàng."
    end
  end

  # DELETE /cart_items/:id
  def destroy
    @cart_item.destroy
    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Đã xóa sản phẩm khỏi giỏ hàng." }
      format.turbo_stream
    end
  end

  private

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
