# frozen_string_literal: true

Rails.application.routes.draw do
  mount Sidekiq::Web => :sidekiq

  devise_for :users
  devise_for :administrators

  root to: redirect("admin/dashboards/today")

  namespace :admin do
    root to: redirect("admin/dashboards/today")
    resources :administrators
    resources :users

    resources :companies do
      resources :working_days
      resources :closing_days
    end

    resources :services do
      resources :working_days
      resources :closing_days
    end

    resources :working_days
    resources :closing_days

    resources :buildings
    resources :service_types
    resources :counters
    resources :user_counters

    resources :shared_clientdisplays

    resources :voiceover_buildings
    resources :voice_overs

    resources :satisfaction_indices
    resources :user_satisfaction_indices

    resources :permisi_roles
    resources :permisi_actor_roles
    resources :permisi_actors

    resources :client_displays

    resources :dashboards do
      get ":type", as: "past", to: "dashboards#index", on: :collection, defaults: {type: "past"}
      get ":type", as: "today", to: "dashboards#index", on: :collection, defaults: {type: "today"}
      get ":type", as: "future", to: "dashboards#index", on: :collection, defaults: {type: "future"}
    end

    resources :play_lists do
      get ":type", as: "musics", to: "play_lists#index", on: :collection, defaults: {type: "music"}
      get ":type", as: "videos", to: "play_lists#index", on: :collection, defaults: {type: "video"}
    end
  end

  namespace :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: 1) do
      scope :caller do
        post :call
        post :recall
        post :transfer
      end

      resources :client_displays do
        get :preload
      end

      resources :tickets, only: %i[index create show]
    end
  end
end
