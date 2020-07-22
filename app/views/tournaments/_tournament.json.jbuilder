json.extract! tournament, :id, :name, :created_at, :updated_at, :current_match_id
json.url tournament_url(tournament, format: :json)
