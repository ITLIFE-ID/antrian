# frozen_string_literal: true

Rails.application.routes.draw do
  mount Sidekiq::Web => :sidekiq
  devise_for :administrators

  root to: redirect("admin/dashboards/today")

  # authenticated :administrator do
  namespace :admin do
    resources :digital_receipts, only: [:show], param: :uuid
    root to: redirect("admin/dashboards/today")
    resources :administrators
    resources :buildings
    resources :client_displays
    resources :closing_days
    resources :callers, only: [:index]
    resources :companies do
      resources :working_days
      resources :closing_days
    end
    resources :counters
    resources :dashboards do
      get :past, on: :collection
      get :today, on: :collection
      get :future, on: :collection
      get :user_satisfaction_indices, on: :collection
    end
    resources :file_storages
    # resources :permisi_roles
    # resources :permisi_actor_roles
    # resources :permisi_actors
    resources :play_lists
    resources :service_types
    resources :working_days
    resources :services do
      resources :working_days
      resources :closing_days
    end
    resources :shared_clientdisplays
    resources :satisfaction_indices
    resources :user_counters
    resources :user_satisfaction_indices, only: [:index, :show]
    resources :users
    resources :voiceover_buildings
    resources :voice_overs

    resources :digital_receipts, only: [:index]
  end

  namespace :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: 1) do
      devise_for :users
      resources :load_configs, only: [:index]
      resources :callers, only: [:create]
    end
  end
end
