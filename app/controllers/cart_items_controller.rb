class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_item, only: [:update, :destroy, :show]

  def index
    @cart_items = current_user.cart_items.includes(:food_drink)
    @total_price = total_price
  end

  # ✅ Thêm sản phẩm vào giỏ hàng
  def create
    food_drink = FoodDrink.find(params[:food_drink_id])
    @cart_item = current_user.cart_items.find_or_initialize_by(food_drink: food_drink)
    @cart_item.quantity = @cart_item.persisted? ? @cart_item.quantity + 1 : 1

    if @cart_item.save
      @cart_items = current_user.cart_items.includes(:food_drink)
      @total_price = total_price

      respond_to do |format|
        format.turbo_stream # -> render create.turbo_stream.erb
        format.html { redirect_to cart_path, notice: "Đã thêm sản phẩm vào giỏ hàng." }
      end
    else
      respond_to do |format|
        format.html { redirect_to food_drinks_path, alert: "Không thể thêm sản phẩm vào giỏ hàng." }
      end
    end
  end

  # ✅ Cập nhật số lượng sản phẩm trong giỏ
  def update
    if @cart_item.update(cart_item_params)
      @cart_items = current_user.cart_items.includes(:food_drink)
      @total_price = total_price

      respond_to do |format|
        format.turbo_stream # -> render update.turbo_stream.erb
        format.html { redirect_to cart_path, notice: "Đã cập nhật giỏ hàng." }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "Không thể cập nhật số lượng." }
        format.html { redirect_to cart_path, alert: "Không thể cập nhật số lượng." }
      end
    end
  end

  # ✅ Xóa sản phẩm khỏi giỏ hàng
  def destroy
    @cart_item.destroy
    @cart_items = current_user.cart_items.includes(:food_drink)
    @total_price = total_price

    respond_to do |format|
      format.turbo_stream # -> render destroy.turbo_stream.erb
      format.html { redirect_to cart_path, notice: "Đã xóa sản phẩm khỏi giỏ hàng." }
    end
  end

  # ✅ Tránh lỗi "Unknown action 'show'"
  def show
    redirect_to cart_path
  end

  private

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  end

  def cart_item_params
    # Phải có dạng params: { cart_item: { quantity: 2 } }
    params.require(:cart_item).permit(:quantity)
  end

  def total_price
    current_user.cart_items.sum { |item| item.food_drink.price * item.quantity }
  end
end
