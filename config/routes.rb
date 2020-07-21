Rails.application.routes.draw do
  devise_for :users
  resources :bets
  resources :matches
  resources :wrestlers
  resources :tournaments do
    get "bet" => "tournaments#bet"
    get "display" => "tournaments#display"
    get "not_in_session" => "tournaments#not_in_session"
  end

  root to: "tournaments#index"
end
