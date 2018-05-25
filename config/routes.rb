Rails.application.routes.draw do
  namespace :admin do
      resources :buildings
      resources :spaces

      root to: "buildings#index"
    end
  resources :persons, only: [:index, :show], as: :people
  resources :spaces, only: [:index, :show]
  resources :buildings, only: [:index, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
