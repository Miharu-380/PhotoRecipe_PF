FactoryBot.define do
  factory :post do
    user
    title { Faker::JapaneseMedia::StudioGhibli.movie }
    photo_app { Faker::Lorem.characters(number: 5) }
    body { Faker::JapaneseMedia::StudioGhibli.quote }
    image { File.open(File.join(Rails.root, 'spec/fixtures/photo_sample.jpg')) }
  end
end