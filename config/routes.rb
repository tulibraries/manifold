Rails.application.routes.draw do
  devise_for :accounts, controllers: { omniauth_callbacks: 'accounts/omniauth_callbacks' }
  namespace :admin do
    resources :accounts
    resources :alerts
    resources :buildings
    resources :groups
    resources :highlights
    resources :people
    resources :spaces

    root to: "people#index"
  end
  root  'application#index'
  resources :alerts, only: [:index, :show]
  resources :persons, only: [:index, :show], as: :people
  resources :spaces, only: [:index, :show]
  resources :buildings, only: [:index, :show]
  resources :groups, only: [:index, :show]
  resources :highlights, only: [:show]

end
