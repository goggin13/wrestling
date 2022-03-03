Rails.application.routes.draw do
  resources :colleges
  devise_for :users
  resources :users
  resources :bets
  resources :matches do
    post "open" => "matches#open"
    post "close" => "matches#close"
    post "winner" => "matches#winner"
  end

  resources :wrestlers
  resources :tournaments do
    get "bet" => "tournaments#bet"
    get "display" => "tournaments#display"
    get "not_in_session" => "tournaments#not_in_session"
    get "administer" => "tournaments#administer"
  end

  root to: "tournaments#index"
end
