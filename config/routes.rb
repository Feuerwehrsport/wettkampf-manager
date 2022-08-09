# frozen_string_literal: true

Rails.application.routes.draw do
  root 'dashboard#show'

  get :logout, to: 'sessions#destroy', as: :logout
  get :login, to: 'sessions#new', as: :login
  get :flyer, to: 'dashboard#flyer'
  get :create_backup, to: 'dashboard#create_backup'
  get :impressum, to: 'dashboard#impressum'
  resources :sessions, only: [:create]
  resources :users

  resources :presets, only: %i[index show update]
  resource :competitions, only: %i[show edit update]
  resources :disciplines
  resources :assessments
  resources :people do
    member do
      get :edit_assessment_requests
      get :statistic_suggestions
    end
    collection { get :without_statistics_id }
  end
  namespace :teams do
    resource :import, only: %i[new create]
  end
  resources :teams do
    member do
      get :edit_assessment_requests
      get :statistic_suggestions
      patch :enrolled
    end
    collection { get :without_statistics_id }
  end
  namespace :score do
    resource :list_factories, only: %i[new create edit update destroy] do
      collection { get 'copy_list/:list_id', action: :copy_list, as: :copy_list }
    end
    resources :lists, only: %i[show edit update index destroy] do
      member do
        get :move
        get :select_entity
        get 'destroy_entity/:entry_id', action: :destroy_entity, as: :destroy_entity
        get :edit_times
      end
      resources :runs, only: %i[edit update], param: :run
    end
    resources :results
    resources :competition_results, only: %i[new create index edit update destroy]
  end

  namespace :fire_sport_statistics do
    resources :suggestions, only: [] do
      collection do
        get :people
        get :teams
      end
    end
    resource :publishing, only: %i[new create]
  end

  namespace :certificates do
    resources :templates do
      member do
        post :duplicate
        post :remove_file
      end
    end
    resources :lists, only: %i[new create] do
      collection do
        post :export
      end
    end
    resource :import, only: %i[new create]
  end

  namespace :imports do
    resources :configurations
  end

  namespace :series do
    resources :rounds, only: %i[index show]
    resources :assessments, only: [:show]
  end

  namespace :api do
    resources :time_entries, only: %i[index show edit update create] do
      member do
        patch :ignore
      end
      collection do
        patch :ignore_all
      end
    end
  end

  if Rails.env.development? || Rails.env.test?
    get 'not_found', to: 'errors#not_found'
    get 'internal_server_error', to: 'errors#internal_server_error'
    get 'unprocessable_entity', to: 'errors#unprocessable_entity'
  end
end
