FactoryBot.define do
  factory :bet do
    association :user
    association :match
    type { "MoneyLineBet" }
    amount { 1.5 }
    wager { "home" }
    payout { 1.5 }

    initialize_with { type.present? ? type.constantize.new : MoneyLineBet.new }
  end
end
