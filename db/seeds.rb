require 'faker'
Faker::Config.locale = :ja

Admin.create!(
   email: 'admin@admin',
   password: 'testtest'
)