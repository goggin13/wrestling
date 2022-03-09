json.extract! bet, :id, :user_id, :match_id, :type, :amount, :wager, :payout, :created_at, :updated_at
json.url bet_url(bet, format: :json)
