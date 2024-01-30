Rails.application.routes.draw do
  root 'homepage#index'
  get '/feeds' => 'feeds#index'

  resources :users, only: [:create]
  resources :sessions, only: [:create, :destroy]
  resources :tweets, only: [:create, :destroy, :index]
  
  get '/authenticated', to: 'sessions#authenticated'
  get '/users/:username/tweets', to: 'tweets#index_by_user'
  delete '/sessions', to: 'sessions#destroy'
  # Redirect all other paths to index page, which will be taken over by AngularJS
  get '*path' => 'homepage#index'
end
