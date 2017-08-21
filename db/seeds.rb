# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


30.times do
  name = Faker::Zelda.unique.character
  User.create(
    name: name,
    email: Faker::Internet.safe_email(name),
    password: "foobar",
    password_confirmation: "foobar",
    hometown: Faker::Zelda.location,
    birthday: Faker::Date.between(400.years.ago, Date.today)
  )
end
