# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :accounts, controllers: { omniauth_callbacks: "accounts/omniauth_callbacks" }
  namespace :admin do
    resources :accounts
    resources :alerts
    resources :blogs
    resources :buildings
    resources :collections
    resources :events
    resources :exhibitions
    resources :groups
    resources :finding_aids
    resources :highlights
    resources :library_hours
    resources :people
    resources :policies
    resources :services
    resources :spaces

    resource :events do
      member do
        post :sync
      end
    end

    resource :library_hours do
      member do
        post :sync
      end
    end

    resource :blogs do
      member do
        post :sync_all
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
  resources :events, only: [:index, :show]
  resources :services, only: [:index, :show]
  resources :policies, only: [:index, :show]
  resources :exhibitions, only: [:index, :show]
  resources :library_hours, only: [:index, :show], as: :hours, path: "/hours"
  resources :forms, only: [:new, :create]
  resources :finding_aids, only: [:show]

  get "forms", to: "forms#all"
  get "forms/*type", to: "forms#new"

  # controller :collections do
  #   get "finding_aids/:id" => :finding_aids
  # end
  #
  # If a finding aid can belong to multiple collections, we can't
  # determine which collection to display as the parent collection

  controller :events do
    get "events/past" => :index
  end


  controller :pages do
    get "ambler" => :ambler
    get "hsl" => :hsl
  end
end
