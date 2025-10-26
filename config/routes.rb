Rails.application.routes.draw do
  # ======================
  # Đăng ký / đăng nhập người dùng
  # ======================
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }


  # ======================
  # Khu vực ADMIN
  # ======================
  namespace :admin do
    get "dashboard", to: "dashboard#index"

    resources :users
    resources :categories
    resources :food_drinks, except: [:show]
    resources :orders, only: [:index, :show, :update, :destroy]
    resources :suggestions, only: [:index, :show, :edit, :update, :destroy]
  end

  # ======================
  # Trang chủ
  # ======================
  root "pages#home"

  # ======================
  # Khu vực USER
  # ======================
  resources :food_drinks, only: [:index, :show] do
    resources :ratings, only: [:create, :update]
  end

  # Giỏ hàng
  resources :cart_items, only: [:create, :update, :destroy]
  get "cart", to: "cart_items#index", as: :cart

  # Hồ sơ người dùng
  resource :profile, only: [:show, :edit, :update]

  # Góp ý
  resources :suggestions

  # Đơn hàng
  resources :orders, only: [:index, :show, :update, :create]
end
