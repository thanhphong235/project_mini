# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    get "dashboard", to: "dashboard#index"

    resources :users
    resources :categories
    resources :food_drinks, except: [:show]   # Admin không có show
    resources :orders, only: [:index, :show, :update, :destroy]
  end

  root "pages#home"

  # Người dùng bình thường
  resources :food_drinks, only: [:index, :show] do
    resources :ratings, only: [:create, :update]
  end

  
  # Giỏ hàng
  resources :cart_items, only: [:create, :update, :destroy]
  get "cart", to: "cart_items#index", as: :cart


  # Profile
  resource :profile, only: [:show, :edit, :update]

  # Suggestions
  resources :suggestions, only: [:new, :create]

  # Orders
  resources :orders, only: [:index, :show, :update, :create]
end
