json.extract! user, :id, :created_at, :updated_at, :balance, :formatted_balance
json.url user_url(user, format: :json)
