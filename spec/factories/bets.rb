FactoryBot.define do
  factory :bet do
    association :user
    association :match
    type { "MoneyLineBet" }
    amount { 1.5 }
    wager { "home" }

    initialize_with { type.present? ? type.constantize.new : MoneyLineBet.new }

    trait :money_line do
      type { "MoneyLineBet" }
      wager { "home" }
    end
    trait :spread do
      type { "SpreadBet" }
      wager { "home" }
    end
    trait :over_under do
      type { "OverUnderBet" }
      wager { "under" }
    end
  end
end
