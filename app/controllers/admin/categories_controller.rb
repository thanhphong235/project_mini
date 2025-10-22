module Admin
  class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    def index
      @categories = Category.order(created_at: :desc)
    end

    def show; end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "Danh mục đã được tạo."
      else
        render :new
      end
    end

    def edit; end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Danh mục đã được cập nhật."
      else
        render :edit
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: "Danh mục đã bị xóa."
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description)
    end

    def require_admin
      redirect_to root_path, alert: "Không có quyền truy cập!" unless current_user.admin?
    end
  end
end
