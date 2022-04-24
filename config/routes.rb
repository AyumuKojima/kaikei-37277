Rails.application.routes.draw do
  devise_for :users
  root to: 'years#index'
  resources :years, only: :index do
    resources :months, only: [:index, :show] do
      resources :spends, only: [:index, :create, :update, :destroy]
      resources :categories, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
