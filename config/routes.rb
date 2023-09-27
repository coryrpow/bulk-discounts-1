Rails.application.routes.draw do
  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy]
    resources :item_status, only: [:update]
    resources :invoices, only: [:index, :show, :update]
  end

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, except: [:destroy]
    resources :merchant_status, only: [:update]
    resources :invoices, except: [:new, :destroy]
  end

  get "/merchants/:id/bulk_discounts", to: "bulk_discounts#index"


  get "/merchants/:id/bulk_discounts/new", to: "bulk_discounts#new", as: "new_merchant_bulk_discount"
  get "/merchants/:id/bulk_discounts/:id", to: "bulk_discounts#show"

  post "/merchants/:id/bulk_discounts", to: "bulk_discounts#create"
end
