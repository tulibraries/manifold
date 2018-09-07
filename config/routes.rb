Rails.application.routes.draw do
  devise_for :accounts, controllers: { omniauth_callbacks: 'accounts/omniauth_callbacks' }
  namespace :admin do
      resources :accounts
      resources :buildings
      resources :spaces
      resources :people
      resources :groups

      root to: "buildings#index"
    end
  root  'application#index'
  resources :persons, only: [:index, :show], as: :people
  resources :spaces, only: [:index, :show]
  resources :buildings, only: [:index, :show]
  resources :groups, only: [:index, :show]
  controller :library_hours do
    get 'hours' => :index
    get 'hours/:id' => :show
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
