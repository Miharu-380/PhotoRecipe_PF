FactoryBot.define do
  factory :post do
    user
    title { Faker::JapaneseMedia::StudioGhibli.movie }
    body { Faker::JapaneseMedia::StudioGhibli.quote }
    image { File.open(File.join(Rails.root, 'spec/fixtures/photo_sample.jpg')) }
  end
end