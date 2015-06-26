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

  def seed_method_dcup_simple
    dcup_seed(false)
  end

  def dcup_seed(all_disciplines=true)
    Competition.update_all(
      group_score_count: 4, 
      group_assessment: true, 
      youth_name: "U20", 
      competition_result_type: "dcup",
      d_cup: true,
    )

    hb = Disciplines::ObstacleCourse.create!
    hl = Disciplines::ClimbingHookLadder.create!
    gs = Disciplines::GroupRelay.create!
    fs = Disciplines::FireRelay.create! if all_disciplines
    zk = Disciplines::DoubleEvent.create!
    la = Disciplines::FireAttack.create!

    competition_results = [:female, :male].map do |gender|
      competition_result = Score::CompetitionResult.create(gender: gender)

      zk_assessment = Assessment.create!(discipline: zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)
      zk_result_youth = Score::DoubleEventResult.create!(assessment: zk_assessment, youth: true)

      hb_assessment = Assessment.create!(discipline: hb, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result)
      Score::Result.create!(assessment: hb_assessment, youth: true, double_event_result: zk_result_youth)

      hl_assessment = Assessment.create!(discipline: hl, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result)
      Score::Result.create!(assessment: hl_assessment, youth: true, double_event_result: zk_result_youth)

      la_assessment = Assessment.create!(discipline: la, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: la_assessment, group_assessment: true)

      if all_disciplines
        fs_assessment = Assessment.create!(discipline: fs, gender: gender, score_competition_result: competition_result)
        Score::Result.create!(assessment: fs_assessment, group_assessment: true)
      end

      competition_result
    end

    gs_assessment = Assessment.create!(discipline: gs, gender: :female, score_competition_result: competition_results.first)
    Score::Result.create!(assessment: gs_assessment, group_assessment: true)
  end

  def seed_method_dcup_all
    dcup_seed
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