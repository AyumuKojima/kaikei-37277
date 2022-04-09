Rails.application.routes.draw do
  devise_for :users
  root to: 'spends#index'
  resources :spends, only: [:index, :create]
  resources :categories, only: [:index, :create]
end
