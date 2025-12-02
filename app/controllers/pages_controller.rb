class PagesController < ApplicationController
  def home
    @categories = Category.all # Food, Drink…
  @selected_category = params[:category_id]

  @food_drinks = FoodDrink.all
  @food_drinks = @food_drinks.where(category_id: @selected_category) if @selected_category.present?
  end
end
