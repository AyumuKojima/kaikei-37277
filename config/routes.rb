Rails.application.routes.draw do
  devise_for :users
  root to: 'spends#index'
  resources :spends, only: :index
end
