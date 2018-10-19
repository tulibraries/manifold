# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :accounts, controllers: { omniauth_callbacks: "accounts/omniauth_callbacks" }
  namespace :admin do
    resources :accounts
    resources :alerts
    #resources :blogs
    resources :buildings
    resources :groups
    resources :highlights
    resources :people
    resources :spaces
    resources :events
    resources :services

    root to: "people#index"
  end
  root "pages#home"
  resources :alerts, only: [:index, :show]
  resources :persons, only: [:index, :show], as: :people
  resources :spaces, only: [:index, :show]
  resources :blogs, only: [:index, :show]
  resources :buildings, only: [:index, :show]
  resources :groups, only: [:index, :show]
  resources :highlights, only: [:show]
  resources :events, only: [:index, :show]
  resources :services, only: [:index, :show]
  resources :library_hours, only: [:index, :show], as: :hours, path: "/hours"

  controller :pages do 
    get 'ambler' => :ambler
  end
end
