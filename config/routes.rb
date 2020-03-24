Rails.application.routes.draw do
  resources :matches
  resources :entries
  resources :brackets
  resources :users
  post '/login', to: 'sessions#create'
  get '/current', to: 'sessions#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
