# frozen_string_literal: true

Rails.application.routes.draw do
  authenticate :administrators do
    mount Sidekiq::Web => :sidekiq
  end

  devise_for :users
  devise_for :administrators

  root to: "admin/dashboards#today"
  namespace :admin do
    resources :dashboards do
      get :past, on: :collection
      get :today, on: :collection
      get :future, on: :collection
    end
    resources :voiceover_buildings
    resources :voice_overs
    resources :user_satisfaction_indices
    resources :users
    resources :user_counters
    resources :service_working_days
    resources :service_types
    resources :service_closing_days
    resources :service_clientdisplays
    resources :services
    resources :satisfaction_indices
    resources :permisi_roles
    resources :permisi_actor_roles
    resources :permisi_actors
    resources :counters
    resources :company_working_days
    resources :company_closing_days
    resources :companies
    resources :client_displays
    resources :buildings
    resources :today_queues
    resources :administrators
    resources :backup_queues

    root to: "dashboards#today"
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
