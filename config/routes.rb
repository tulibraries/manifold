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
    resources :policies
    resources :collections

    resource :events do
      member do
        post :sync
      end
    end

    root to: "people#index"
  end

  root "pages#home"
  resources :alerts, only: [:index, :show]
  resources :blog_posts, only: [:index, :show]
  resources :persons, only: [:index, :show], as: :people, path: "people"
  resources :spaces, only: [:index, :show]
  resources :blogs, only: [:index, :show]
  resources :buildings, only: [:index, :show], path: "libraries"
  resources :groups, only: [:index, :show]
  resources :collections, only: [:index, :show]
  resources :events, only: [:index, :show], path: "/beyondthepage"
  resources :services, only: [:index, :show]
  resources :policies, only: [:index, :show]
  resources :library_hours, only: [:index, :show], as: :hours, path: "/hours"
  resources :forms, only: [:new, :create]

  get "forms", to: "forms#all"
  get "forms/*type", to: "forms#new"


  controller :pages do
    get "ambler" => :ambler
    get "hsl" => :hsl
  end
end
