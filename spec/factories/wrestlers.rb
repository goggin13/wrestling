FactoryBot.define do
  factory :wrestler do
    sequence(:name) { |n| "Test Wrestler #{n % 10}" }
    college_year { 2013 }
    bio { "MyText" }
  end
end
