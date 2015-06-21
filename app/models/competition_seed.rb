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
      ],
      [
        "Jugend-Elbe-Elster 2015", 
        "*", 
        :seed_method_jugend_elbe_elster
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
      Competition.one.update_attributes!(configured: true)
    end
  end

  private

  def climbing_hook_ladder group_assessment, female=nil, male=nil
    climbing_hook_ladder = Disciplines::ClimbingHookLadder.create!
    male_assessment = Assessment.create!(discipline: climbing_hook_ladder, gender: :male, score_competition_result: male)
    male_result = Score::Result.create!(assessment: male_assessment, group_assessment: group_assessment)
    female_assessment = Assessment.create!(discipline: climbing_hook_ladder, gender: :female, score_competition_result: female)
    female_result = Score::Result.create!(assessment: female_assessment, group_assessment: group_assessment)
    [male_result, female_result]
  end

  def fire_attack group_assessment, female=nil, male=nil
    fire_attack = Disciplines::FireAttack.create!
    male_assessment = Assessment.create!(discipline: fire_attack, gender: :male, score_competition_result: male)
    male_result = Score::Result.create!(assessment: male_assessment, group_assessment: group_assessment)
    female_assessment = Assessment.create!(discipline: fire_attack, gender: :female, score_competition_result: female)
    female_result = Score::Result.create!(assessment: female_assessment, group_assessment: group_assessment)
    [male_result, female_result]
  end

  def obstacle_course group_assessment, female=nil, male=nil
    obstacle_course = Disciplines::ObstacleCourse.create!
    male_assessment = Assessment.create!(discipline: obstacle_course, gender: :male, score_competition_result: male)
    male_result = Score::Result.create!(assessment: male_assessment, group_assessment: group_assessment)
    female_assessment = Assessment.create!(discipline: obstacle_course, gender: :female, score_competition_result: female)
    female_result = Score::Result.create!(assessment: female_assessment, group_assessment: group_assessment)
    [male_result, female_result]
  end

  def group_relay group_assessment, female=nil, male=nil
    group_relay = Disciplines::GroupRelay.create!
    female_assessment = Assessment.create!(discipline: group_relay, gender: :female, score_competition_result: female)
    female_result = Score::Result.create!(assessment: female_assessment, group_assessment: group_assessment)
    [female_result]
  end

  def fire_relay group_assessment, female=nil, male=nil
    fire_relay = Disciplines::FireRelay.create!
    male_assessment = Assessment.create!(discipline: fire_relay, gender: :male, score_competition_result: male)
    male_result = Score::Result.create!(assessment: male_assessment, group_assessment: group_assessment)
    female_assessment = Assessment.create!(discipline: fire_relay, gender: :female, score_competition_result: female)
    female_result = Score::Result.create!(assessment: female_assessment, group_assessment: group_assessment)
    [male_result, female_result]
  end

  def double_event result_lists
    double_event = Disciplines::DoubleEvent.create!
    result_lists.map do |result_list|
      assessment = Assessment.create!(discipline: double_event, gender: result_list.first.assessment.gender)
      double_event_result = Score::DoubleEventResult.create!(assessment: assessment)
      result_list.each do |result|
        result.double_event_result = double_event_result
        result.save!
      end
      double_event_result
    end
  end

  def seed_method_dcup_simple
    Competition.update_all(
      group_score_count: 4, 
      group_assessment: true, 
      youth_name: "U20", 
      competition_result_type: "dcup",
      d_cup: true,
    )
    result_female = Score::CompetitionResult.create(gender: :female)
    result_male   = Score::CompetitionResult.create(gender: :male)

    chl_results = climbing_hook_ladder true, result_female, result_male
    oc_results = obstacle_course true, result_female, result_male
    de_results = double_event [[chl_results.first, oc_results.first], [chl_results.last, oc_results.last]]
    fire_attack true, result_female, result_male
    group_relay true, result_female, result_male
    
    de_male_youth = Score::DoubleEventResult.create!(assessment: de_results.first.assessment, youth: true)
    de_female_youth = Score::DoubleEventResult.create!(assessment: de_results.last.assessment, youth: true)
    Score::Result.create!(assessment: chl_results.first.assessment, youth: true, double_event_result: de_male_youth)
    Score::Result.create!(assessment: chl_results.last.assessment, youth: true, double_event_result: de_female_youth)
    Score::Result.create!(assessment: oc_results.first.assessment, youth: true, double_event_result: de_male_youth)
    Score::Result.create!(assessment: oc_results.last.assessment, youth: true, double_event_result: de_female_youth)
  end

  def seed_method_dcup_all
  end

  def seed_method_jugend_elbe_elster
    Competition.update_all(
      group_assessment: true, 
      youth_name: "", 
      competition_result_type: "places_to_points"
    )

    ak1_female = Score::CompetitionResult.create!(gender: :female, name: "AK1")
    ak1_male   = Score::CompetitionResult.create!(gender: :male, name: "AK1")
    ak2_female = Score::CompetitionResult.create!(gender: :female, name: "AK2")
    ak2_male   = Score::CompetitionResult.create!(gender: :male, name: "AK2")

    # Gruppenstafette
    group_relay = Disciplines::GroupRelay.create!
    assessment = Assessment.create!(discipline: group_relay, gender: :female, name: "AK1 Gruppenstafette Mädchen", score_competition_result: ak1_female)
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: group_relay, gender: :male, name: "AK1 Gruppenstafette Jungen", score_competition_result: ak1_male)
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: group_relay, gender: :female, name: "AK2 Gruppenstafette Mädchen", score_competition_result: ak2_female)
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: group_relay, gender: :male, name: "AK2 Gruppenstafette Jungen", score_competition_result: ak2_male)
    Score::Result.create!(assessment: assessment, group_assessment: true)

    # 5x80 Meter-Staffel
    fire_relay = Disciplines::FireRelay.create!(name: "5x80-Meter-Staffel", short_name: "5x80")
    assessment = Assessment.create!(discipline: fire_relay, gender: :female, name: "AK1 Staffel Mädchen", score_competition_result: ak1_female)
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_relay, gender: :male, name: "AK1 Staffel Jungen", score_competition_result: ak1_male)
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_relay, gender: :female, name: "AK2 Staffel Mädchen", score_competition_result: ak2_female)
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_relay, gender: :male, name: "AK2 Staffel Jungen", score_competition_result: ak2_male)
    Score::Result.create!(assessment: assessment, group_assessment: true)

    # Löschangriff
    fire_attack = Disciplines::FireAttack.create!
    assessment = Assessment.create!(discipline: fire_attack, gender: :female, name: "AK1 Löschangriff Mädchen", score_competition_result: ak1_female)
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: "AK1 Löschangriff Jungen", score_competition_result: ak1_male)
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_attack, gender: :female, name: "AK2 Löschangriff Mädchen", score_competition_result: ak2_female)
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: "AK2 Löschangriff Jungen", score_competition_result: ak2_male)
    Score::Result.create!(assessment: assessment, group_assessment: true)

    # Hakenleitersteigen
    chl = Disciplines::ClimbingHookLadder.create!
    # Hindernisbahn
    oc = Disciplines::ObstacleCourse.create!
    [
      [:female, "AK1 10-12 DIS Mädchen"],
      [:female, "AK1 13-14 DIS Mädchen"],
      [:male, "AK1 10-12 DIS Jungen"],
      [:male, "AK1 13-14 DIS Jungen"],
      [:female, "AK2 15-16 DIS Mädchen"],
      [:female, "AK2 17-18 DIS Mädchen"],
      [:male, "AK2 15-16 DIS Jungen"],
      [:male, "AK2 17-18 DIS Jungen"],
    ].each do |ak|
      assessment = Assessment.create!(discipline: chl, gender: ak.first, name: ak.last.gsub("DIS", "Hakenleitersteigen"))
      Score::Result.create!(assessment: assessment)
      assessment = Assessment.create!(discipline: oc, gender: ak.first, name: ak.last.gsub("DIS", "Hindernisbahn"))
      Score::Result.create!(assessment: assessment)
    end
  end

  def seed_method_la
    fire_attack false
  end
end