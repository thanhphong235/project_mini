Rails.application.routes.draw do
  # ======================
  # Devise: Đăng ký / đăng nhập người dùng + OmniAuth
  # ======================
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # ======================
  # Trang chủ
  # ======================
  root "pages#home"

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
