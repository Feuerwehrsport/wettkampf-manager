# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

competition = Competition.new(
  name: 'Wettkampf',
  date: Date.current,
  flyer_text: "Beispiel:\n\n* WLAN-Name: Wettkampf-WLAN\n* WLAN-Passwort: Feuerwehrsport",
)
competition.create_possible = true
competition.save!

if Rails.env.test? && ENV['SET_USER_PASSWORD']
  User.create!(name: 'admin', password: 'admin')
  User.create!(name: 'API', password: 'API')
else
  user = User.new(name: 'admin')
  user.save!(validate: false)

  user = User.new(name: 'API')
  user.save!(validate: false)
end
