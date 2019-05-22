# frozen_string_literal: true

Rails.application.routes.draw do

  concern :imageable do
    get "image/thumbnail", to: "images#thumbnail_image"
    get "image/medium",    to: "images#medium_image"
    get "image/large",     to: "images#large_image"
  end


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
    resources :pages
    resources :library_hours
    resources :people
    resources :policies
    resources :services
    resources :spaces
    resources :categories
    resources :external_links

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
  resources :persons, only: [:index, :show], as: :people, path: "people", concerns: [:imageable]
  resources :spaces, only: [:index, :show], concerns: [:imageable]
  resources :blogs, only: [:index, :show]
  resources :buildings, only: [:index, :show], path: "libraries", concerns: [:imageable]
  resources :groups, only: [:index, :show]
  resources :collections, only: [:index, :show], concerns: [:imageable]
  resources :services, only: [:index, :show], concerns: [:imageable]
  resources :policies, only: [:index, :show]
  resources :events, only: [:index, :show], constraints: { id: /[0-9]+/ }, concerns: [:imageable]
  resources :exhibitions, only: [:index, :show], concerns: [:imageable]
  resources :library_hours, only: [:index, :show], as: :hours, path: "/hours"
  resources :forms, only: [:new, :create]
  resources :finding_aids, only: [:index, :show]
  resources :pages, only: [:index, :show]
  resources :highlights, only: [:index, :show]

  get "forms", to: "forms#all"
  get "forms/*type", to: "forms#new"

  controller :collections do
    get "finding_aids/:id" => :finding_aids
  end

  controller :events do
    get "events/past" => :past, as: "past_events"
  end

  controller :pages do
    get "ambler" => :ambler
    get "hsl" => :hsl
    get "about" => :about, as: "pages_about"
    get "research-services" => :research, as: "pages_research"
    get "visit-study" => :visit, as: "pages_visit"
    get "home" => :home, as: "pages_home"
    get "ask-us-email" => :ask_us_email, as: "pages_ask_us_email"
  end
end
