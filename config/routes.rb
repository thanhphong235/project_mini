Rails.application.routes.draw do
  devise_for :users

  # Admin namespace
  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :food_drinks, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  # Food & Drinks routes
  resources :food_drinks

  # Trang chủ
  get "pages/home"
  root "pages#home"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
