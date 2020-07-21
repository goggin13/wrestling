FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "klynch425@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
