FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_#{n % 10}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    balance { 1000 }

    trait :admin do
      email { "goggin13@gmail.com" }
    end
  end
end
