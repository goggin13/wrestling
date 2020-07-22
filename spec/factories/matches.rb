FactoryBot.define do
  factory :match do
    weight { 1 }
    association :home_wrestler, factory: :wrestler
    association :away_wrestler, factory: :wrestler
    winner_id { nil }
    tournament { nil }
  end
end
