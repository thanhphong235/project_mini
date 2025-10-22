class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    fd = FoodDrink.find(params[:food_drink_id])
    cart_item = current_user.cart_items.find_or_initialize_by(food_drink: fd)
    cart_item.quantity = (cart_item.quantity || 0) + 1
    cart_item.save
    redirect_back fallback_location: food_drinks_path, notice: "Đã thêm vào giỏ hàng."
  end

  def update
    cart_item = CartItem.find(params[:id])
    cart_item.update(quantity: params[:cart_item][:quantity])
    redirect_back fallback_location: food_drinks_path
  end

  def destroy
    CartItem.find(params[:id]).destroy
    redirect_back fallback_location: food_drinks_path
  end
end
