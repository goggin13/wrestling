Rails.application.routes.draw do
  resources :colleges
  devise_for :users
  resources :users
  resources :bets do
  end
  post "bets/pickem" => "bets#create_pickem"
  resources :money_line_bets, :controller => 'bets'
  resources :spread_bets, :controller => 'bets'
  resources :over_under_bets, :controller => 'bets'
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
    get "pickem" => "tournaments#pickem"
  end

  root to: "tournaments#index"
end
