Rails.application.routes.draw do
  get 'weather', to: 'weather#show'
  root 'weather#index'
end
