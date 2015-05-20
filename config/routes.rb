Rails.application.routes.draw do
  root 'dashboard#show'

  get :logout, to: "sessions#destroy", as: :logout
  get :login, to: "sessions#new", as: :login
  resources :sessions, only: [:create]
  resources :users, only: [:edit, :update]

  resources :competition_seeds, only: [:show] do
    member { post :execute }
  end
  resources :competitions, only: [:show, :edit, :update]
  resources :disciplines, only: [:index, :new, :create, :show, :destroy]
  resources :assessments
  resources :people do
    member { get :edit_assessment_requests }
  end
  resources :teams do
    member { get :edit_assessment_requests }
  end
  namespace :score do
    resources :lists do
      member do
        get :move
        get :finished
        get :select_entity
        get "destroy_entity/:entry_id", action: :destroy_entity, as: :destroy_entity
      end
      resources :runs, only: [:edit, :update], param: :run
    end
    resources :results
  end

  namespace :fire_sport_statistics do
    resources :suggestions, only: [] do
      collection do
        get :people
        get :teams
      end
    end
  end
end

