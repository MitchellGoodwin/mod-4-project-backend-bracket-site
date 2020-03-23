# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
tbracket = Bracket.all.last

12.times do
    user = User.create(username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'test')
    Entry.create(user: user, bracket: tbracket, seed: tbracket.entries.size + 1)
end