Rails.application.routes.draw do
  get 'menus/index'
  get 'contacts/index'
  get 'gallerys/index'
  get 'events/index'
  get 'abouts/index'
  get 'about/index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # ======================
  # DEVISE CHO USER
  # ======================
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations",   # <-- SỬA TẠI ĐÂY !!!
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  root "pages#home"

  # ======================
  # DEVISE CHO ADMIN
  # ======================
  

  namespace :admin do
    get "dashboard", to: "dashboard#index", as: :dashboard

    resources :users
    resources :categories
    resources :food_drinks, except: [:show] do
      collection { delete :bulk_delete }
    end
    resources :orders, only: [:index, :show, :update, :destroy]
    resources :suggestions, only: [:index, :show, :edit, :update, :destroy]

    get "order_statistics", to: "dashboard#order_statistics", as: "order_statistics"
    post "send_monthly_report", to: "dashboard#send_monthly_report", as: "send_monthly_report"
  end

  # ======================
  # USER AREA
  # ======================
  resources :food_drinks do
    resources :ratings, only: [:edit, :create, :update, :destroy]
  end

  resources :cart_items, only: [:create, :update, :destroy]
  get "cart", to: "cart_items#index", as: :cart

  resource :profile, only: [:show, :edit, :update]
  resources :suggestions
  resources :chefs, only: [:index]
  resources :abouts, only: [:index]
  resources :events, only: [:index]
  resources :gallerys, only: [:index]
  resources :contacts, only: [:index, :create]

  resources :orders, only: [:index, :show, :update, :create] do
    member { patch :cancel }
  end

  if Rails.env.production?
    get "/run_seed", to: "application#run_seed"
  end
end
