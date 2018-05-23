Rails.application.routes.draw do
  resources :spaces, only: [:index, :show]
  resources :buildings, only: [:index, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
