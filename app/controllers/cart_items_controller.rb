class CartItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_item, only: [:update, :destroy]

  # GET /cart
  def index
    @cart_items = current_user.cart_items.includes(:food_drink)
    @total_price = total_price
  end

  # POST /cart_items
  def create
    food_drink = FoodDrink.find(params[:food_drink_id])

    if food_drink.stock <= 0
      respond_to do |format|
        format.html { redirect_to food_drinks_path, alert: "Món này đã hết hàng." }
        format.turbo_stream { flash.now[:alert] = "Món này đã hết hàng." }
      end
      return
    end

    # Giảm stock ngay khi thêm
    food_drink.decrement!(:stock)

    # Thêm vào giỏ
    @cart_item = current_user.cart_items.find_or_initialize_by(food_drink: food_drink)
    @cart_item.quantity = @cart_item.persisted? ? @cart_item.quantity + 1 : 1
    @cart_item.save!

    @cart_items = current_user.cart_items.includes(:food_drink)
    @total_price = total_price

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Đã thêm sản phẩm vào giỏ hàng." }
      format.turbo_stream
    end
  end

  # PATCH/PUT /cart_items/:id
  def update
    new_quantity = cart_item_params[:quantity].to_i
    delta = new_quantity - @cart_item.quantity
    food_drink = @cart_item.food_drink

    if delta > 0
      if food_drink.stock >= delta
        food_drink.decrement!(:stock, delta)
      else
        redirect_back fallback_location: cart_path, alert: "Số lượng trong kho không đủ."
        return
      end
    elsif delta < 0
      food_drink.increment!(:stock, -delta)
    end

    @cart_item.update(quantity: new_quantity)
    @cart_items = current_user.cart_items.includes(:food_drink)
    @total_price = total_price

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "Đã cập nhật giỏ hàng." }
      format.turbo_stream
    end
  end

  # DELETE /cart_items/:id
  def destroy
    food_drink = @cart_item.food_drink
    food_drink.increment!(:stock, @cart_item.quantity)
    @cart_item.destroy

    @cart_items = current_user.cart_items.includes(:food_drink)
    @total_price = total_price

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

  def total_price
    current_user.cart_items.sum { |item| item.food_drink.price * item.quantity }
  end
end
