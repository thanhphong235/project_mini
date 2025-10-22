Rails.application.routes.draw do
  # Devise cho user
  devise_for :users

  # Admin namespace
  namespace :admin do
    # Dashboard
    get "dashboard", to: "dashboard#index", as: :dashboard

    # Quản lý users
    resources :users

    # Quản lý categories
    resources :categories

    # Quản lý food & drinks (products)
    resources :food_drinks

    # Quản lý đơn hàng
    resources :orders, only: [:index, :show, :destroy]
  end

  # Food & Drinks routes cho người dùng bình thường
  resources :food_drinks, only: [:index, :show] do
    # Ratings cho mỗi product
    resources :ratings, only: [:create]

    # Cart cho mỗi product
    resources :cart_items, only: [:create, :update, :destroy]
  end

  # Profile user
  resource :profile, only: [:show, :edit, :update]

  # Suggest food/drink tới admin
  resources :suggestions, only: [:new, :create]

  # Trang chủ
  get "pages/home"
  root "pages#home"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
