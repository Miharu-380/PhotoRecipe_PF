FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 20) }
    username { Faker::Alphanumeric.alpha(number: 15) }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
