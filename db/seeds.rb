# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
Faker::Config.locale = 'fr'

Attendance.destroy_all
Event.destroy_all
User.destroy_all

#Users
30.times do
  # character = Faker::TvShows::Simpsons.character
  # first_n = ""
  # last_n = ""
  # name_char = character.split
  # max = name_char.count - 1
  # i = 0
  # name_char.count.times do |i|
  #   if i == max
  #     last_n = name_char[i]
  #   else
  #     first_n += name_char[i]
  #   end
  # end
  # puts "character>#{character}< ||  first_n>#{first_n}<   last_n>#{last_n}<"
  first_n = Faker::Name.first_name
  last_n = Faker::Name.last_name
  psw = Faker::Ancient.god
  u = User.create(
    first_name: first_n,
    last_name: last_n,
    email: first_n[0].downcase + last_n.downcase + "@yopmail.com",
    password: psw,
    password_confirmation: psw,
    description: Faker::TvShows::Simpsons.quote
    )
    # puts first_n[0] + last_n + "@yopmail.com"
    puts "--User créé : #{u.first_name + " " + u.last_name + " / " + u.email }"
end
puts "Nombre de Users créés : #{User.all.count}/30"

# #Events
20.times do
  quote = Faker::TvShows::Simpsons.quote
  Event.create(
    start_date: Faker::Date.between(from: Date.today, to: 365.days.from_now),
    duration: rand(1..2016)*5, #durée au maximum de 7 jours 
    title: quote[0..139],
    description: quote,
    price: rand(1..1000),
    location: Faker::TvShows::Simpsons.location,
    event_admin_id: User.ids.sample
    )
end
puts "Nombre d'Events créés : #{Event.count}/20"

#Attendances
Event.all.each do |e|
  #Créer 5 participations
  rand(0..10).times do
    Attendance.create(
      user_id: User.ids.sample,
      event_id: e.id,
      stripe_customer_id: ""
    )
  end
end
puts "Nombre de Attendances créés : #{Attendance.count}"
