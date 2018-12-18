Rails.application.routes.draw do
  root 'homes#index'
  get '/homes', to: 'homes#index'
  get '/auth/:provider/callback', to: 'sessions#create'
end
