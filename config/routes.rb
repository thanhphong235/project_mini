Rails.application.routes.draw do
  # ======================
  # Sidekiq Web UI
  # ======================
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # ======================
  # Devise: đăng ký / đăng nhập + OmniAuth
  # ======================
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations",
    sessions: 'users/sessions',
    passwords: 'users/passwords'
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
    resources :food_drinks, except: [:show] do
      collection do
        delete :bulk_delete
      end
    end
    resources :orders, only: [:index, :show, :update, :destroy]
    resources :suggestions, only: [:index, :show, :edit, :update, :destroy]

    get "order_statistics", to: "dashboard#order_statistics", as: "order_statistics"
    post "send_monthly_report", to: "dashboard#send_monthly_report", as: "send_monthly_report"
  end
  # ======================
  # Khu vực USER
  # ======================
  resources :food_drinks do
    resources :ratings, only: [:edit, :create, :update, :destroy] # hoặc thêm :new nếu cần
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
  if Rails.env.production?
    get "/run_seed", to: "application#run_seed"
  end

end
