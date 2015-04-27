class CompetitionSeed

  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :id, :name, :hint, :method
  alias_method :to_param, :id

  def self.seeds
    [
      [
        "Deutschland-Cup (HL, HB, GS, LA)", 
        "*", 
        :seed_method_dcup_simple
      ],
      [
        "Deutschland-Cup (HL, HB, GS, LA, FS)", 
        "*", 
        :seed_method_dcup_all
      ],
      [
        "Löschangriff-Pokallauf (LA)", 
        "*", 
        :seed_method_la
      ]
    ]
  end

  def self.all
    seeds.each_with_index.map { |params, id| new(id: (id+1), name: params[0], hint: params[1], method: params[2]) }
  end

  def self.find(id)
    seed = all.select { |seed| seed.id == id.to_i }.first
    raise ActiveRecord::RecordNotFound if seed.nil?
    seed
  end

  def execute
    ActiveRecord::Base.transaction do
      send method
      Competition.first.update_attributes!(configured: true)
    end
  end

  private

  def climbing_hook_ladder
    climbing_hook_ladder = Disciplines::ClimbingHookLadder.create!
    Assessment.create!(discipline: climbing_hook_ladder, gender: :male, name: "Hakenleitersteigen - männlich")
    Assessment.create!(discipline: climbing_hook_ladder, gender: :female, name: "Hakenleitersteigen - weiblich")
  end

  def fire_attack
    fire_attack = Disciplines::FireAttack.create!
    Assessment.create!(discipline: fire_attack, gender: :male, name: "Löschangriff - männlich")
    Assessment.create!(discipline: fire_attack, gender: :female, name: "Löschangriff - weiblich")
  end

  def obstacle_course
    obstacle_course = Disciplines::ObstacleCourse.create!
    Assessment.create!(discipline: obstacle_course, gender: :male, name: "Hindernisbahn - männlich")
    Assessment.create!(discipline: obstacle_course, gender: :female, name: "Hindernisbahn - weiblich")
  end

  def group_relay
    group_relay = Disciplines::GroupRelay.create!
    Assessment.create!(discipline: group_relay, gender: :female, name: "Gruppenstafette")
  end

  def fire_relay
    fire_relay = Disciplines::FireRelay.create!
    Assessment.create!(discipline: fire_relay, gender: :male, name: "Feuerwehrstafette - männlich")
    Assessment.create!(discipline: fire_relay, gender: :female, name: "Feuerwehrstafette - weiblich")
  end

  def seed_method_dcup_simple
    climbing_hook_ladder
    fire_attack
    obstacle_course
    group_relay
  end

  def seed_method_dcup_all
    hl_female = climbing_hook_ladder
    fire_attack
    obstacle_course
    group_relay
    fire_relay



male_team_mv = Team.create!(name: "Mecklenburg-Vorpommern", gender: "male")
female_team_mv = Team.create!(name: "Mecklenburg-Vorpommern", gender: "female")
p = Person.create!(last_name: 'Rost', first_name: 'Stephanie', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Schmecht', first_name: 'Sabine', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Krüger', first_name: 'Simone', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Herold', first_name: 'Kerstin', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Haase', first_name: 'Christine', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Hüner', first_name: 'Yvonne', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Renk', first_name: 'Kim', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Buhrtz', first_name: 'Juliana', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Daßler', first_name: 'Annekathrin', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Daßler', first_name: 'Sissy', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Keil', first_name: 'Monia', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Porst', first_name: 'Franziska', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Welcher', first_name: 'Cindy', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Lange', first_name: 'Desiree', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Ewald', first_name: 'Anne', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Westphal', first_name: 'Annett', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Thurow', first_name: 'Grit', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Giese', first_name: 'Lisa', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Holzfuß', first_name: 'Andrea', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Werk', first_name: 'Julia', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Petzhold', first_name: 'Martina', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Nogatzki', first_name: 'Katja', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Nogatzki', first_name: 'Elke', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Römer', first_name: 'Tina', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Niefeldt', first_name: 'Susanne', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Schieber', first_name: 'Sophie', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Rambow', first_name: 'Nadine', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Hübschmann', first_name: 'Kerstin', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Ahnert', first_name: 'Diana', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
p = Person.create!(last_name: 'Hildebrandt', first_name: 'Eileen', gender: 'female', team: female_team_mv)
AssessmentRequest.create!(entity: p, assessment: hl_female)
Person.create!(last_name: 'Schmecht', first_name: 'Marcus', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Reichel', first_name: 'Rico', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Ziegler', first_name: 'Philipp', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Thäle', first_name: 'Sebastian', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Parche', first_name: 'Andre', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Recknagel', first_name: 'Ralf', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Bergmann', first_name: 'Andy', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Lüdecke', first_name: 'Steffen', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Grosche', first_name: 'Christian', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Hohenstein', first_name: 'Tobias', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Engel', first_name: 'Marcel', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Marciniak', first_name: 'Roman', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Zitterich', first_name: 'Roy', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Riemer', first_name: 'Olaf', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Plönzke', first_name: 'Matthias', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Benndorf', first_name: 'Thomas', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Hall', first_name: 'Steffen', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Gulitz', first_name: 'Michael', gender: 'male', team: male_team_mv)
Person.create!(last_name: 'Zwick', first_name: 'Sebastian', gender: 'male', team: male_team_mv)


    
  end

  def seed_method_la
    fire_attack
  end
end