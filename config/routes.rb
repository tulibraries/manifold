Rails.application.routes.draw do
  devise_for :accounts, controllers: { omniauth_callbacks: 'accounts/omniauth_callbacks' }
  namespace :admin do
    resources :accounts
    resources :alerts
    resources :buildings
    resources :groups
    resources :people
    resources :spaces
    resources :events

    root to: "people#index"
  end
  root  'application#index'
  resources :alerts, only: [:index, :show]
  resources :persons, only: [:index, :show], as: :people
  resources :spaces, only: [:index, :show]
  resources :buildings, only: [:index, :show]
  resources :groups, only: [:index, :show]
  resources :events, only: [:index, :show]
  controller :library_hours do
    get 'hours' => :index
    get 'hours/:id' => :show
  end
end
