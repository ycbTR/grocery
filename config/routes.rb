Rails.application.routes.draw do
  root controller: :home, action: :index

  resources :account_activities
  resources :line_items
  resources :orders do
    collection do
      post :complete
      post :populate
      delete :remove_item
    end
  end
  resources :accounts
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
