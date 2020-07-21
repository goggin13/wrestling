FactoryBot.define do
  factory :bet do
    wager { "MyString" }
    user { nil }
    match { nil }
  end
end
