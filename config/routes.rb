Rails.application.routes.draw do
  get 'admins/index'
  root 'events#index'
  devise_for :users
  resources :users, only: [:show, :edit, :update] do
    resources :avatars, only: [:create]
  end
  resources :events, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :attendances, only: [:index, :new, :create]
  end
  namespace :admins, only: [:index] do
    resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :avatars, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    end
    resources :events, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :attendances, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    end
  end
end
