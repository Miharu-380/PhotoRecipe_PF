require 'faker'
Faker::Config.locale = :ja

Admin.create!(
   email: ENV['ADMIN_EMAIL'],
   password: ENV['ADMIN_PASSWORD']
)