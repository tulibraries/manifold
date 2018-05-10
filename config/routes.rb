Rails.application.routes.draw do
  namespace :admin do
      resources :buildings
      resources :spaces

      root to: "buildings#index"
    end
  resources :buildings
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
