# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

competition = Competition.new(name: "Wettkampf", date: Date.today, flyer_text: "Beispiel:\n\n* WLAN-Name: Wettkampf-WLAN\n* WLAN-Passwort: Feuerwehrsport")
competition.create_possible = true
competition.save!

user = User.new(name: 'admin')
user.save!(validate: false)


# Team.transaction do
#   old_logger = ActiveRecord::Base.logger
#   ActiveRecord::Base.logger = nil

#   puts "Assessment.transaction do"
#   puts "hb_female = Assessment.discipline(Disciplines::ObstacleCourse.new).gender(:female).first"
#   puts "hb_male = Assessment.discipline(Disciplines::ObstacleCourse.new).gender(:male).first"
#   puts "hl_female = Assessment.discipline(Disciplines::ClimbingHookLadder.new).gender(:female).first"
#   puts "hl_male = Assessment.discipline(Disciplines::ClimbingHookLadder.new).gender(:male).first"
#   Team.includes(:people).all.each do |team|
#     puts "team = Team.create!(name: '#{team.name}', gender: '#{team.gender}', number: #{team.number})"
#     team.people.each do |person|
#       puts "person = Person.create!(last_name: '#{person.last_name}', first_name: '#{person.first_name}', gender: '#{person.gender}', team: team, youth: #{person.youth}, fire_sport_statistics_person_id: #{person.fire_sport_statistics_person_id.inspect})"
#       person.requests.each do |request|
#         assessment = request.assessment.discipline.is_a?(Disciplines::ObstacleCourse) ? 'hb' : 'hl'
#         assessment += "_#{person.gender}"
#         puts "AssessmentRequest.create!(assessment: #{assessment}, entity: person, assessment_type: '#{request.assessment_type}', group_competitor_order: #{request.group_competitor_order}, relay_count: #{request.relay_count}, single_competitor_order: #{request.single_competitor_order})"
#       end
#     end
#   end
#   puts "end"

#   ActiveRecord::Base.logger = old_logger
# end