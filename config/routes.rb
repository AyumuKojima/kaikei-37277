Rails.application.routes.draw do
  root to: 'spends#index'
  resources :spends, only: :index
end
