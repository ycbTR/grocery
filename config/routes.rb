Rails.application.routes.draw do
  resources :stocks
  mount ActionCable.server => '/cable'

  root controller: :home, action: :index

  resource :admin, controller: 'admin' do
    get :auto_logout
  end

  resource :home, controller: 'home' do
    match :login, via: [:get, :post]
    delete :logout
    get :publish_number
    get :publish_backup
    get :reset_cart, format: :js
    get :read
    get :account_details
  end
  resources :account_activities

  resources :reports do
    collection do
      get :detailed_z_report
      get :zreport

    end
  end

  resources :line_items do
    member do
      post :cancel
    end
  end

  resources :orders do
    collection do
      post :complete
      post :populate
      delete :remove_item
    end
    member do
      post :cancel
      post :print
    end
  end
  resources :accounts
  resources :products do
    collection do
      post :update_positions
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
