class SuggestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]

  def index
    @suggestions = current_user.suggestions.order(created_at: :desc)
  end

  def show
  end

  def new
    @suggestion = current_user.suggestions.build
  end

  def create
    @suggestion = current_user.suggestions.build(suggestion_params)
    @suggestion.status = "pending"

    if @suggestion.save
      flash[:success] = "Góp ý của bạn đã được gửi thành công! ❤️"
      redirect_to suggestions_path
    else
      flash[:danger] = "Có lỗi xảy ra, vui lòng thử lại."
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @suggestion.update(suggestion_params)
      flash[:success] = "Cập nhật góp ý thành công!"
      redirect_to suggestions_path
    else
      flash[:danger] = "Không thể cập nhật góp ý, vui lòng thử lại."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @suggestion.destroy
    flash[:success] = "Đã xóa góp ý thành công!"
    redirect_to suggestions_path
  end

  private

  def set_suggestion
    @suggestion = current_user.suggestions.find(params[:id])
  end

  def suggestion_params
    params.require(:suggestion).permit(:title, :content)
  end
end
