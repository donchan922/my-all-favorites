Rails.application.routes.draw do
  root 'users#index'
  get '/users', to: 'users#index'
  get '/auth/:provider/callback', to: 'sessions#create'
end
