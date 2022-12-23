# frozen_string_literal: true

Rails.application.routes.draw do
  authenticate :administrators do
    mount Sidekiq::Web => :sidekiq
  end

  devise_for :users
  devise_for :administrators

  root to: "admin/dashboards#today"

  namespace :admin do
    root to: "dashboards#today"

    resources :dashboards do
      get :past, on: :collection
      get :today, on: :collection
      get :future, on: :collection
    end

    resources :companies
    resources :company_working_days
    resources :company_closing_days

    resources :voiceover_buildings
    resources :voice_overs

    resources :user_counters
    resources :counters
    resources :counter_client_displays

    resources :services
    resources :service_working_days
    resources :service_types
    resources :service_closing_days
    resources :service_clientdisplays

    resources :satisfaction_indices
    resources :user_satisfaction_indices

    resources :permisi_roles
    resources :permisi_actor_roles
    resources :permisi_actors

    resources :client_displays
    resources :buildings

    resources :play_lists do
      get ":type", as: "musics", to: "play_lists#index", on: :collection, defaults: {type: "music"}
      get ":type", as: "videos", to: "play_lists#index", on: :collection, defaults: {type: "video"}
    end

    resources :today_queues do
      get ":type", as: "processed", to: "today_queues#index", on: :collection, defaults: {type: "processed "}
      get ":type", as: "unprocessed", to: "today_queues#index", on: :collection, defaults: {type: "unprocessed"}
      get ":type", as: "offline", to: "today_queues#index", on: :collection, defaults: {type: "offline "}
      get ":type", as: "online", to: "today_queues#index", on: :collection, defaults: {type: "online"}
      get ":type", as: "future_online", to: "today_queues#index", on: :collection, defaults: {type: "future_online "}
      get ":type", as: "future_offline", to: "today_queues#index", on: :collection, defaults: {type: "future_offline"}
    end

    resources :backup_queues do
      get ":type", as: "offline", to: "backup_queues#index", on: :collection, defaults: {type: "offline "}
      get ":type", as: "online", to: "backup_queues#index", on: :collection, defaults: {type: "online"}
    end

    resources :administrators
    resources :users
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
