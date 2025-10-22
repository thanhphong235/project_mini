Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :users
    resources :categories
    resources :food_drinks
    resources :orders, only: [:index, :show, :destroy]
  end

  root "pages#home"

  resources :food_drinks, only: [:index, :show] do
    resources :ratings, only: [:create]
  end

  # Giỏ hàng
  resources :cart_items, only: [:create, :update, :destroy]
  get "cart", to: "cart_items#index", as: :cart

  resource :profile, only: [:show, :edit, :update]
  resources :suggestions, only: [:new, :create]
  resources :orders, only: [:index, :show, :create]

end
