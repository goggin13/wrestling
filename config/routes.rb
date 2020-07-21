Rails.application.routes.draw do
  resources :bets
  resources :matches
  resources :wrestlers
  resources :tournaments
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
