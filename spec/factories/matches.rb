FactoryBot.define do
  factory :match do
    weight { 1 }
    home_wrestler_id { 1 }
    away_wrestler_id { 1 }
    winner_id { 1 }
    tournament { nil }
  end
end
