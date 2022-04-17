Rails.application.routes.draw do
  devise_for :users
  root to: 'years#index'
  resources :years, only: :index do
    resources :months, only: [:index, :show] do
      resources :spends, only: [:index, :create]
      resources :categories, only: [:index, :create]
    end
  end
end
