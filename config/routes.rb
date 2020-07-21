Rails.application.routes.draw do
  devise_for :users
  resources :bets
  resources :matches
  resources :wrestlers
  resources :tournaments do
    get "bet" => "tournaments#bet"
  end

  root to: "tournaments#index"
end
