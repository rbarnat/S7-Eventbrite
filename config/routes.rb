Rails.application.routes.draw do
  root 'events#index'
  devise_for :users
  resources :users, only: [:show, :edit, :update] do
    resources :avatars, only: [:create]
  end
  resources :events, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :attendances, only: [:index, :new, :create]
  end
end
