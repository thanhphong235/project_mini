Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'


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

      # Thêm route thống kê đơn hàng
    get "order_statistics", to: "dashboard#order_statistics", as: "order_statistics"
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
