class CompetitionSeed

  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :id, :name, :hints, :method
  alias_method :to_param, :id

  def self.seeds
    [
      [
        "Leere Vorlage", 
        [
          "Es wird nichts angelegt.",
        ], 
        :seed_method_nothing
      ],
      [
        "Hallenpokal HB + FS", 
        [
          "100m Hindernisbahn für Frauen und Männer",
          "4x100m für Frauen und Männer",
        ], 
        :seed_method_hallenpokal
      ],
      [
        "Deutschland-Cup (HL, HB, GS, LA)", 
        [
          "Hakenleitersteigen, 100m Hindernisbahn, Zweikampf für Frauen und Männer",
          "4 Personen von 8 gehen in die Mannschaftswertung ein",
          "Hakenleitersteigen, 100m Hindernisbahn, Zweikampf - U20 Wertung",
          "Löschangriff für Frauen und Männer",
          "Gruppenstaffete für Frauen",
          "Gesamtwertung mit 1. Platz => 10 Punkte",
          "D-Cup Gesamtwertung",
        ], 
        :seed_method_dcup_simple
      ],
      [
        "Deutschland-Cup (HL, HB, GS, LA, FS)", 
        [
          "Hakenleitersteigen, 100m Hindernisbahn, Zweikampf für Frauen und Männer",
          "4 Personen von 8 gehen in die Mannschaftswertung ein",
          "Hakenleitersteigen, 100m Hindernisbahn, Zweikampf - U20 Wertung",
          "Löschangriff und 4x100m Staffel für Frauen und Männer",
          "Gruppenstaffete für Frauen",
          "Gesamtwertung mit 1. Platz => 10 Punkte",
          "D-Cup Gesamtwertung",
        ], 
        :seed_method_dcup_all
      ],
      [
        "Löschangriff-Pokallauf (LA)", 
        [
          "Löschangriff für Frauen und Männer",
        ], 
        :seed_method_la
      ],
      [
        "Landesmeisterschaft Thüringen 2016", 
        [
          "Löschangriff für Frauen und Männer",
          "Mehrkampf für Frauen und Männer mit (HL, HB, GS, LA, FS)",
          "10 Personen dürfen starten",
        ], 
        :seed_method_landesmeisterschaft_thueringen_2016
      ],
      [
        "Jugend-Elbe-Elster 2015", 
        [], 
        :seed_method_jugend_elbe_elster
      ],
      [
        "Stadtmeisterschaften Sonnewalde 2015",
        [
          "Frauen: Gruppenstaffete, 4x100m Feuerwehrstaffette, 100m Hindernisbahn, Hakenleitersteigen, Löschangriff Nass; Ü40 Löschangriff Nass",
          "Männer: 4x100m Feuerwehrstaffette, 100m Hindernisbahn, Hakenleitersteigen, Löschangriff Nass, Ü40 Löschangriff Nass",
          "Kinder jeweils m/w und AKI AKII: Gruppenstaffete, 5x80m Feuerwehrstaffette, Löschangriff Nass",
          "Kinder AKI 10-12; AKI 13-14; AKII 15-16; AKII 17-18 jeweils m/w: 100m Hindernisbahn, Hakenleitersteigen",
        ],
        :seed_method_stadtmeisterschaft_sonnewalde
      ],
      [
        "MV-Cup (HL, HB)",
        [
          "Frauen: 100m Hindernisbahn, Hakenleitersteigen, Zweikampf",
          "Männer: 100m Hindernisbahn, Hakenleitersteigen, Zweikampf",
        ],
        :seed_method_mv_cup
      ]
    ]
  end

  def self.all
    seeds.each_with_index.map { |params, id| new(id: (id+1), name: params[0], hints: params[1], method: params[2]) }
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

  def seed_method_mv_cup
    Competition.update_all(
      name: "MV-Cup",
    )

    hb = Disciplines::ObstacleCourse.create!
    hl = Disciplines::ClimbingHookLadder.create!
    zk = Disciplines::DoubleEvent.create!
    
    [:female, :male].each do |gender|
      zk_assessment = Assessment.create!(discipline: zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)

      hb_assessment = Assessment.create!(discipline: hb, gender: gender)
      Score::Result.create!(assessment: hb_assessment, double_event_result: zk_result)

      hl_assessment = Assessment.create!(discipline: hl, gender: gender)
      Score::Result.create!(assessment: hl_assessment, double_event_result: zk_result)
    end
  end

  def dcup_seed(all_disciplines=true)
    Competition.update_all(
      group_score_count: 4, 
      group_assessment: true, 
      competition_result_type: "dcup",
    )
    youth_tag = PersonTag.create!(name: "U20", competition: Competition.first)

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
      zk_result_youth = Score::DoubleEventResult.create!(assessment: zk_assessment, tag_references_attributes: [{ tag_id: youth_tag.id }])

      hb_assessment = Assessment.create!(discipline: hb, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result)
      Score::Result.create!(assessment: hb_assessment, double_event_result: zk_result_youth, tag_references_attributes: [{ tag_id: youth_tag.id }])

      hl_assessment = Assessment.create!(discipline: hl, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result)
      Score::Result.create!(assessment: hl_assessment, double_event_result: zk_result_youth, tag_references_attributes: [{ tag_id: youth_tag.id }])

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

  def seed_method_stadtmeisterschaft_sonnewalde
    Competition.update_all(
      name: "Stadtmeisterschaften Sonnewalde",
      place: "Sonnewalde",
      date: Date.parse("2015-07-04"),
      group_assessment: true,
      competition_result_type: ""
    )

    hb = Disciplines::ObstacleCourse.create!
    hl = Disciplines::ClimbingHookLadder.create!
    gs = Disciplines::GroupRelay.create!
    fs = Disciplines::FireRelay.create!
    zk = Disciplines::DoubleEvent.create!
    la = Disciplines::FireAttack.create!


    [:female, :male].map do |gender|
      zk_assessment = Assessment.create!(discipline: zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)

      hb_assessment = Assessment.create!(discipline: hb, gender: gender)
      Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result)

      hl_assessment = Assessment.create!(discipline: hl, gender: gender)
      Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result)

      la_assessment = Assessment.create!(discipline: la, gender: gender)
      Score::Result.create!(assessment: la_assessment, group_assessment: true)

      la_assessment = Assessment.create!(discipline: la, gender: gender, name: "Löschangriff - #{I18n.t("gender.#{gender}")} - Ü40")
      Score::Result.create!(assessment: la_assessment, group_assessment: true)

      fs_assessment = Assessment.create!(discipline: fs, gender: gender)
      Score::Result.create!(assessment: fs_assessment, group_assessment: true)
    end

    gs_assessment = Assessment.create!(discipline: gs, gender: :female)
    Score::Result.create!(assessment: gs_assessment, group_assessment: true)

    # Gruppenstafette
    group_relay = Disciplines::GroupRelay.create!(name: "Gruppenstafette Jugend", short_name: "GS J")
    assessment = Assessment.create!(discipline: group_relay, gender: :female, name: "AK1 Gruppenstafette Mädchen")
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: group_relay, gender: :male, name: "AK1 Gruppenstafette Jungen")
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: group_relay, gender: :female, name: "AK2 Gruppenstafette Mädchen")
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: group_relay, gender: :male, name: "AK2 Gruppenstafette Jungen")
    Score::Result.create!(assessment: assessment, group_assessment: true)

    # 5x80 Meter-Staffel
    fire_relay = Disciplines::FireRelay.create!(name: "5x80-Meter-Staffel", short_name: "5x80")
    assessment = Assessment.create!(discipline: fire_relay, gender: :female, name: "AK1 Staffel Mädchen")
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_relay, gender: :male, name: "AK1 Staffel Jungen")
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_relay, gender: :female, name: "AK2 Staffel Mädchen")
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_relay, gender: :male, name: "AK2 Staffel Jungen")
    Score::Result.create!(assessment: assessment, group_assessment: true)

    # Löschangriff
    fire_attack = Disciplines::FireAttack.create!(name: "Löschangriff Jugend", short_name: "LA J")
    assessment = Assessment.create!(discipline: fire_attack, gender: :female, name: "AK1 Löschangriff Mädchen")
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: "AK1 Löschangriff Jungen")
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_attack, gender: :female, name: "AK2 Löschangriff Mädchen")
    Score::Result.create!(assessment: assessment, group_assessment: true)
    assessment = Assessment.create!(discipline: fire_attack, gender: :male, name: "AK2 Löschangriff Jungen")
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
    la = Disciplines::FireAttack.create!
    [:female, :male].map do |gender|
      la_assessment = Assessment.create!(discipline: la, gender: gender)
      Score::Result.create!(assessment: la_assessment, group_assessment: true)
    end
  end

  def seed_method_nothing
  end

  def seed_method_hallenpokal
    hb = Disciplines::ObstacleCourse.create!
    fs = Disciplines::FireRelay.create!

    [:female, :male].each do |gender|
      hb_assessment = Assessment.create!(discipline: hb, gender: gender)
      Score::Result.create!(assessment: hb_assessment, group_assessment: false)

      fs_assessment = Assessment.create!(discipline: fs, gender: gender)
      Score::Result.create!(assessment: fs_assessment, group_assessment: false)
    end
  end

  def seed_method_landesmeisterschaft_thueringen_2016
    Competition.update_all(
      group_score_count: 4,
      group_run_count: 10, 
      group_assessment: true, 
      competition_result_type: "places_to_points",
      place: "Zeulenroda",
      date: Date.parse("2016-05-21"),
      name: "Landesmeisterschaft Thüringen",
    )

    hb = Disciplines::ObstacleCourse.create!
    hl = Disciplines::ClimbingHookLadder.create!
    gs = Disciplines::GroupRelay.create!
    fs = Disciplines::FireRelay.create!
    zk = Disciplines::DoubleEvent.create!
    la = Disciplines::FireAttack.create!

    mehrkampf = TeamTag.create!(name: "Mehrkampf", competition: Competition.first)
    nur_la = TeamTag.create!(name: "Nur LA", competition: Competition.first)

    competition_results = [:female, :male].map do |gender|
      competition_result = Score::CompetitionResult.create(gender: gender, name: "Mehrkampf")

      zk_assessment = Assessment.create!(discipline: zk, gender: gender)
      zk_result = Score::DoubleEventResult.create!(assessment: zk_assessment)

      hb_assessment = Assessment.create!(discipline: hb, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: hb_assessment, group_assessment: true, double_event_result: zk_result)

      hl_assessment = Assessment.create!(discipline: hl, gender: gender, score_competition_result: competition_result)
      Score::Result.create!(assessment: hl_assessment, group_assessment: true, double_event_result: zk_result)

      la_assessment = Assessment.create!(
        discipline: la, 
        gender: gender, 
        score_competition_result: competition_result, 
        name: "Löschangriff - Mehrkampf - #{I18n.t("gender.#{gender}")}", 
        tag_references_attributes: [{ tag_id: mehrkampf.id }],
      )
      Score::Result.create!(assessment: la_assessment, group_assessment: true)

      fs_assessment = Assessment.create!(
        discipline: fs, 
        gender: gender, 
        score_competition_result: competition_result, 
        tag_references_attributes: [{ tag_id: mehrkampf.id }],
      )
      Score::Result.create!(assessment: fs_assessment, group_assessment: true)

      competition_result
    end

    gs_assessment = Assessment.create!(
      discipline: gs, 
      gender: :female, 
      score_competition_result: competition_results.first, 
      tag_references_attributes: [{ tag_id: mehrkampf.id }],
    )
    Score::Result.create!(assessment: gs_assessment, group_assessment: true)


    competition_results = [:female, :male].map do |gender|
      la_assessment = Assessment.create!(
        discipline: la, 
        gender: gender, 
        name: "Löschangriff - nur LA - #{I18n.t("gender.#{gender}")}", 
        tag_references_attributes: [{ tag_id: nur_la.id }],
      )
      Score::Result.create!(assessment: la_assessment)
    end
  end
end