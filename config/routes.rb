# frozen_string_literal: true

Rails.application.routes.draw do

  mount Rswag::Api::Engine => "/"
  mount Rswag::Ui::Engine  => "api-docs"

  concern :imageable do
    get "image/thumbnail", to: "images#thumbnail_image"
    get "image/medium",    to: "images#medium_image"
    get "image/large",     to: "images#large_image"
  end


  devise_for :accounts, controllers: { omniauth_callbacks: "accounts/omniauth_callbacks" }
  namespace :admin do
    resources :accounts
    resources :admin_groups
    resources :alerts
    resources :blogs
    resources :buildings
    resources :categories
    resources :collections
    resources :events
    resources :exhibitions
    resources :external_links
    resources :finding_aids
    resources :file_uploads
    resources :groups
    resources :highlights
    resources :library_hours
    resources :people
    resources :policies
    resources :redirects
    resources :services
    resources :spaces
    resources :webpages

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

    resource :buildings, :categories, :collections, :events, :exhibitions, :file_uploads, :groups, :highlights, :webpages, :people, :spaces do
      member do
        get ":id/detach" => :detach
      end
    end

    resource :buildings, :categories, :collections, :events, :exhibitions, :file_uploads, :groups, :highlights, :webpages, :people, :spaces do
      member do
        post "detach" => :detach
      end
    end

    root to: "people#index"

  end

  direct(:admin_blob) { |blob, options| route_for(:admin_active_storage_blob, blob, options) }
  direct(:admin_blobs) { |opts| route_for(:admin_active_storage_blobs, opts) }
  direct(:edit_admin_blob) { |blob, opts| route_for(:edit_admin_active_storage_blob, blob, opts) }
  direct(:admin_attachment) { |attachment, options| route_for(:admin_active_storage_attachment, attachment, options) }
  direct(:admin_attachments) { |opts| route_for(:admin_active_storage_attachments, opts) }
  direct(:edit_admin_attachment) { |attachment, opts| route_for(:edit_admin_active_storage_attachment, attachment, opts) }

  root "webpages#home"
  resources :alerts, only: [:index]
  resources :buildings, only: [:index, :show], path: "libraries", concerns: [:imageable]
  resources :categories, only: [:index, :show], concerns: [:imageable]
  resources :blogs, only: [:index, :show]
  resources :collections, only: [:index, :show], concerns: [:imageable]
  resources :events, only: [:index, :show], constraints: { id: /[0-9]+/ }, concerns: [:imageable]
  resources :exhibitions, only: [:index, :show], concerns: [:imageable]
  resources :external_link, only: [:show]
  resources :forms, only: [:new, :create]
  resources :file_uploads, only: [:new, :create]
  resources :finding_aids, only: [:index, :show]
  resources :groups, only: [:index, :show]
  resources :highlights, only: [:index, :show]
  resources :library_hours, only: [:index, :show], as: :hours, path: "/hours"
  resources :persons, only: [:index, :show], as: :people, path: "people", concerns: [:imageable]
  resources :policies, only: [:index, :show]
  resources :services, only: [:index, :show], concerns: [:imageable]
  resources :spaces, only: [:index, :show], concerns: [:imageable]
  resources :webpages, only: [:index, :show]

  get "forms", to: "forms#all", as: "forms_index"
  get "forms/*type", to: "forms#new"

  controller :collections do
    get "finding_aids/:id" => :finding_aids
  end

  controller :events do
    get "events/past" => :past, as: "past_events"
  end

  controller :blogs do
    get "news" => :index, as: "news"
  end

  controller :scrc do
    get "scrc/*path" => :show
    get "collections/scrc/*path" => :show
  end

  controller :persons do
    get "people/specialists/print" => :specialists_print, as: "specialists_print"
  end

  controller :webpages do
    get "scrc" => :scrc, as: "webpages_scrc"
    get "blockson" => :blockson, as: "webpages_blockson"
    get "ambler" => :ambler, as: "webpages_ambler"
    get "hsl" => :hsl, as: "webpages_hsl"
    get "contact-us" => :contact, as: "webpages_contact"
    get "about" => :about, as: "webpages_about"
    get "research-services" => :research, as: "webpages_research"
    get "visit-study" => :visit, as: "webpages_visit"
    get "home" => :home, as: "webpages_home"
    get "lcdss" => :tudsc, as: "webpages_lcdss"
    get "wpvi" => :wpvi
    get "watchpastprograms" => :videos_all, as: "webpages_videos_all"
    get "watchpastprograms/list/:collection" => :videos_list, as: "webpages_videos_collection"
    get "watchpastprograms/search" => :videos_search, as: "webpages_videos_search"
    get "watchpastprograms/show" => :videos_show, as: "webpages_videos_show"
    get "/pages/:id" => :show
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/503", to: "errors#service_unavailable", via: :all

  controller :redirects do
    get "*path" => :show,
      constraints: lambda { |req| req.path.exclude? "rails/active_storage" }
  end

end

Rails.application.routes.named_routes.url_helpers_module.module_eval do
  def external_link_url(external_link, options = {})
    external_link.link
  end
end

Rails.application.routes.named_routes.path_helpers_module.module_eval do
  def external_link_path(external_link, options = {})
    external_link.link
  end
end
