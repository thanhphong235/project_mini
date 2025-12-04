class Admin::SuggestionsController < Admin::BaseController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]

  def index
    @suggestions = Suggestion.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @suggestion.update(suggestion_params)
      redirect_to admin_suggestions_path, notice: "Cập nhật trạng thái thành công."
    else
      render :edit, alert: "Có lỗi xảy ra, vui lòng thử lại."
    end
  end

  def destroy
    @suggestion.destroy
    redirect_to admin_suggestions_path, notice: "Đã xóa góp ý."
  end

  private

  def check_admin
    redirect_to root_path, alert: "Bạn không có quyền truy cập!" unless current_user.admin?
  end

  def set_suggestion
    @suggestion = Suggestion.find(params[:id])
  end

  def suggestion_params
    params.require(:suggestion).permit(:status)
  end
end
