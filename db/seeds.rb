require 'faker'
Faker::Config.locale = :ja

Admin.create!(
   email: ENV['ADMIN_USERNAME'],
   password: ENV['ADMIN_PASSWORD']
)