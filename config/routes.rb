Rails.application.routes.draw do
  root "expenses#index"

  resources :categories
  resources :payment_methods

  resources :expenses do
    collection do
      get :paid
      get :this_month
    end
  end
end