FactoryBot.define do
  factory :match do
    weight { 1 }
    spread { -3 }
    over_under { 10 }
    closed { false }
    association :home_wrestler, factory: :wrestler
    association :away_wrestler, factory: :wrestler
    association :tournament

    trait :closed do
      closed { true }
    end
  end
end
